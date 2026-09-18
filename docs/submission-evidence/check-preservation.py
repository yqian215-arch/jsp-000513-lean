from pathlib import Path
import subprocess, json, re, hashlib
root=Path.cwd()
out=root/'docs/submission-evidence'
base='8496ddb257bbdd9948417d3a98a563f2696cd47b'
def git(*a): return subprocess.check_output(['git',*a],cwd=root)
def strip_comments(s):
    s=re.sub(r'/\-.*?\-/', '', s, flags=re.S)
    s=re.sub(r'--[^\n]*','',s)
    return ''.join(s.split())
rows=[]
files=git('ls-tree','-r','--name-only',base,'JSP000513').decode().splitlines()
for f in files:
    if not f.endswith('.lean'):continue
    old=git('show',base+':'+f).decode()
    new=(root/f).read_text(encoding='utf-8-sig')
    normalized=new.replace('omit [DecidableEq α] in\n','').replace('omit [DecidableEq Color] in\n','')
    ok=strip_comments(old)==strip_comments(normalized)
    rows.append({'file':f,'unchanged_code_after_exact_allowed_omit_and_comment_removal':ok})
assert all(r['unchanged_code_after_exact_allowed_omit_and_comment_removal'] for r in rows)
for f in ['lean-toolchain','lakefile.toml','lake-manifest.json']:
    assert git('show',base+':'+f).decode().replace('\r\n','\n')==(root/f).read_text(encoding='utf-8-sig')
(out/'core-preservation.json').write_text(json.dumps(rows,indent=2)+'\n')
# Screening reports locations only, never credential values.
patterns={
 'private_key':re.compile(rb'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----'),
 'github_token':re.compile(rb'\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,})\b'),
 'aws_access_key':re.compile(rb'\bAKIA[A-Z0-9]{16}\b'),
 'credential_in_url':re.compile(rb'https?://[^\s/:]+:[^\s/@]+@'),
}
hits=[];checked=0
for line in git('rev-list','--objects','HEAD').decode().splitlines():
    parts=line.split(' ',1)
    if len(parts)<2:continue
    oid,path=parts
    if git('cat-file','-t',oid).strip()!=b'blob':continue
    data=git('cat-file','blob',oid);checked+=1
    for kind,pat in patterns.items():
        if pat.search(data):hits.append({'object':oid,'path':path,'kind':kind})
for p in [root/'README.md',root/'ATTRIBUTION.md',*list((root/'docs').glob('SUBMISSION*.md')),root/'docs/LICENSE_RECOMMENDATION.md']:
    data=p.read_bytes()
    for kind,pat in patterns.items():
        if pat.search(data):hits.append({'path':str(p.relative_to(root)),'kind':kind})
result={'reachable_history_blobs_screened':checked,'credential_pattern_hits':hits,
 'scope':'Pattern screening of reachable HEAD history plus new public-facing documents; not a guarantee against every private datum. Local machine paths and generic automation identities remain intentionally recorded. No public email inferred.'}
(out/'publication-screen.json').write_text(json.dumps(result,indent=2)+'\n')
print('Existing Lean module code preserved:',len(rows),'all PASS; locked configuration unchanged')
print('Reachable history blobs screened:',checked,'credential-pattern hits:',len(hits))

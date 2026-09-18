from pathlib import Path
import re,json,hashlib,subprocess
root=Path(r'D:\Lean\jsp-000513-cleanroom\repo');out=root/'docs/cleanroom-evidence'
files=subprocess.check_output(['git','ls-tree','-r','--name-only','83644d1838aadee8fc7acd9150c610aff5402ba7'],cwd=root,text=True).splitlines()
pat=re.compile(r'\b(?:sorry|admit|sorryAx|axiom|unsafe|native_decide|implemented_by|extern|partial)\b|debug\.skipKernelTC|trustLevel|ofReduceBool|\b(?:TODO|FIXME|placeholder)\b',re.I)
def classify(s):
 mask=['code']*len(s);i=0;depth=0
 while i<len(s):
  if s.startswith('/-',i):
   start=i;depth=1;i+=2
   while i<len(s) and depth:
    if s.startswith('/-',i):depth+=1;i+=2
    elif s.startswith('-/',i):depth-=1;i+=2
    else:i+=1
   mask[start:i]=['comment']*(i-start)
  elif s.startswith('--',i):
   start=i;i=s.find('\n',i)
   if i<0:i=len(s)
   mask[start:i]=['comment']*(i-start)
  elif s[i]=='"':
   start=i;i+=1
   while i<len(s):
    if s[i]=='\\':i+=2
    elif s[i]=='"':i+=1;break
    else:i+=1
   mask[start:i]=['string']*(i-start)
  else:i+=1
 return mask
result=[];hashes=[]
for f in files:
 p=root/f
 if p.suffix not in ['.lean','.ps1','.toml']:continue
 s=p.read_text(encoding='utf-8-sig');mask=classify(s) if p.suffix=='.lean' else None
 hits=[{'line':s.count('\n',0,m.start())+1,'token':m.group(),'category':mask[m.start()] if mask else 'configuration/script','text':s.splitlines()[s.count('\n',0,m.start())]} for m in pat.finditer(s)]
 result.append({'file':f,'hits':hits})
 hashes.append({'file':f,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
(out/'source-scan.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(out/'source-files-sha256.json').write_text(json.dumps(hashes,indent=2)+'\n',encoding='utf-8')
print('Base source/config/script files scanned:',len(result));print('Hits:',json.dumps([x for x in result if x['hits']],ensure_ascii=False))
# independent finite exhaustive obstruction from paper lists
from itertools import combinations,product
ls=[{1,2,5,6},{1,4,5,6},{3,4,5,6},{3,4,5,6},{2,4,5,6}]
choices=[[set(c) for c in combinations(sorted(l),2)] for l in ls]
candidates=0;solutions=0
for assignment in product(*choices):
 candidates+=1
 if all(assignment[i].isdisjoint(assignment[(i+1)%5]) for i in range(5)):solutions+=1
assert candidates==7776 and solutions==0
(out/'independent-c5-enumeration.txt').write_text(f'Paper lists, 5 cycle edges, 2-subsets: candidates={candidates}, solutions={solutions}\n')
print('Independent C5 enumeration:',candidates,solutions)

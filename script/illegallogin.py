# -*- coding:utf-8 -*-

import os
import sys

#获取ip
ip=os.popen("who -u | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' |sort -t'.' -k1,1nr -k2,2nr -k3,3nr -k4,4nr |uniq").read().split("\n")

#判断是否要删除ip
newip=ip
Whitelist=[]
for num in range(1,len(sys.argv)):
    newip=' '.join(newip).replace(sys.argv[num], "").split()
    Whitelist.append(sys.argv[num])

nulll=0
if len(newip) == 0:
    newip=Whitelist
    nulll=1

#获取登录信息
data=[]
if nulll == 0:
    for i in newip:
        if i != '':
            #执行获取信息的命令,分割后添加到数组
            datatmp=os.popen("who -u | grep '%s'  "%i).read().split('\n')
            for ii in os.popen("who -u | grep '%s'  "%i).read().split('\n'):
                if ii != '':
                    data.append(ii.replace('\n',""))
else:
    data.append(os.popen("who -u ").read())
print "%s\n"%' '.join(newip)
print '\n'.join(data)

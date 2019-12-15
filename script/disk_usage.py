#! /usr/bin/env python
import re
import os
import sys
import StringIO


def read(filename):
    with open(filename, 'r') as f:
        data = f.readlines()
    return data


def mount_pos():
    filename = "/etc/mtab"
    dev_name_list = list()
    for x in read(filename):
        dev_name = x.strip().split()[0:2]
        if re.match("/dev", dev_name[0]):
            dev_name_list.append(dev_name)
    return dev_name_list

def size_cal():
    dev_list = list()
    for x in mount_pos():
       tmp_parrtion_info = os.statvfs(x[1])
       tmp_total =  float(tmp_parrtion_info.f_frsize * tmp_parrtion_info.f_blocks) / 1024 / 1024
       tmp_free =  float(tmp_parrtion_info.f_frsize * tmp_parrtion_info.f_bavail) / 1024 / 1024
       tmp_used =  float(tmp_parrtion_info.f_frsize * (tmp_parrtion_info.f_blocks - tmp_parrtion_info.f_bfree)) / 1024 /1024
       dev_list.append({
           x[0]: {
               'total': tmp_total,
               'free': tmp_free,
               'used': tmp_used
            }
          })
    
    return dev_list


def disk_sum():
    disk_info = size_cal()
    total = 0
    free = 0
    used = 0
    for x in disk_info:
        for k, v in x.items():
            total += v['total']
            free += v['free']
            used += v['used']

    return {'total': total, 'free': free, 'used': used }

if __name__ == '__main__':
    print disk_sum()

use strict;
use Test::More tests => 2668;

use HTTP::MobileAgent::Plugin::Extension qw(ez_judgeKDDITUKA);

my @Tests = (
  'KDDI-HI31 UP.Browser/6.2.0.5 (GUI) MMP/2.0',
  'Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.1.17.65.000001/0.1/C100) Opera 7.0',
  'J-PHONE/4.2/V601SH/SNJSHH1157880 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1',
  'DoCoMo/1.0/SH505i2/c20/TB/W24H12'
);

my @IPS = (
  ["219.125.148.184","A|T"],,
  ["218.222.1.153","A|T"],,
  ["219.125.148.177","A|T"],,
  ["219.125.148.181","A|T"],,
  ["219.125.148.179","A|T"],,
  ["219.125.148.180","A|T"],,
  ["219.125.148.183","A|T"],,
  ["219.125.148.185","A|T"],,
  ["218.222.1.171","A|T"],,
  ["219.125.148.173","A|T"],
  ["218.222.1.156","A|T"],
  ["219.125.148.205","A|T"],
  ["219.125.148.203","A|T"],
  ["219.125.148.200","A|T"],
  ["219.125.148.172","A|T"],
  ["219.125.148.213","A|T"],
  ["218.222.1.137","A|T"],
  ["219.125.148.211","A|T"],
  ["218.222.1.170","A|T"],
  ["219.125.148.174","A|T"],
  ["219.125.148.178","A|T"],
  ["219.125.148.210","A|T"],
  ["218.222.1.172","A|T"],
  ["219.125.148.176","A|T"],
  ["219.125.148.182","A|T"],
  ["219.125.148.170","A|T"],
  ["219.125.148.175","A|T"],
  ["219.125.148.207","A|T"],
  ["219.125.148.171","A|T"],
  ["218.222.1.169","A|T"],
  ["218.222.1.141","A|T"],
  ["219.125.148.212","A|T"],
  ["219.125.148.206","A|T"],
  ["219.125.148.202","A|T"],
  ["218.222.1.140","A|T"],
  ["218.222.1.154","A|T"],
  ["218.222.1.138","A|T"],
  ["219.125.148.204","A|T"],
  ["219.125.148.201","A|T"],
  ["218.222.1.155","A|T"],
  ["218.222.1.139","A|T"],
  ["61.117.1.150","A|T"],
  ["61.117.0.76","A|T"],
  ["211.5.7.236","A|T"],
  ["61.117.0.66","A|T"],
  ["61.117.0.199","A|T"],
  ["61.117.0.69","A|T"],
  ["61.117.0.182","A|T"],
  ["61.117.0.234","A|T"],
  ["61.117.0.185","A|T"],
  ["61.117.0.165","A|T"],
  ["61.117.0.166","A|T"],
  ["211.5.2.166","A|T"],
  ["61.117.0.203","A|T"],
  ["222.7.56.26","A|T"],
  ["222.7.56.20","A|T"],
  ["222.7.56.24","A|T"],
  ["222.7.56.16","A|T"],
  ["222.7.56.18","A|T"],
  ["222.7.56.19","A|T"],
  ["222.7.56.27","A|T"],
  ["222.7.56.25","A|T"],
  ["222.7.56.21","A|T"],
  ["222.7.56.23","A|T"],
  ["222.7.56.22","A|T"],
  ["222.7.56.17","A|T"],
  ["61.117.0.201","A|T"],
  ["61.117.0.230","A|T"],
  ["61.117.0.181","A|T"],
  ["61.117.1.149","A|T"],
  ["61.117.0.216","A|T"],
  ["61.117.0.202","A|T"],
  ["211.5.2.142","A|T"],
  ["211.5.2.138","A|T"],
  ["211.5.2.202","A|T"],
  ["211.5.2.172","A|T"],
  ["61.117.0.169","A|T"],
  ["61.117.0.187","A|T"],
  ["61.117.0.214","A|T"],
  ["61.117.0.65","A|T"],
  ["211.5.2.201","A|T"],
  ["211.5.2.174","A|T"],
  ["61.117.0.162","A|T"],
  ["211.5.2.163","A|T"],
  ["61.117.0.70","A|T"],
  ["61.117.0.189","A|T"],
  ["61.117.0.161","A|T"],
  ["219.108.158.26","A|T"],
  ["61.117.2.34","A|T"],
  ["211.5.2.224","A|T"],
  ["61.117.0.220","A|T"],
  ["221.119.1.160","H"],
  ["61.198.250.58","H"],
  ["221.119.8.84","H"],
  ["210.168.247.237","H"],
  ["221.119.3.69","H"],
  ["61.198.253.214","H"],
  ["221.119.2.141","H"],
  ["210.168.246.140","H"],
  ["219.108.15.98","H"],
  ["221.119.8.4","H"],
  ["221.119.3.173","H"],
  ["219.108.15.89","H"],
  ["61.198.249.253","H"],
  ["221.119.8.68","H"],
  ["61.198.253.233","H"],
  ["221.119.8.64","H"],
  ["210.168.247.125","H"],
  ["221.119.3.129","H"],
  ["221.119.1.69","H"],
  ["221.119.1.9","H"],
  ["221.119.2.199","H"],
  ["219.108.15.67","H"],
  ["221.119.1.133","H"],
  ["221.119.1.228","H"],
  ["61.198.167.129","H"],
  ["61.198.253.176","H"],
  ["219.108.15.16","H"],
  ["210.168.246.150","H"],
  ["210.168.247.39","H"],
  ["221.119.9.233","H"],
  ["61.198.253.227","H"],
  ["210.168.247.110","H"],
  ["221.119.2.217","H"],
  ["221.119.2.17","H"],
  ["210.168.247.1","H"],
  ["210.168.247.121","H"],
  ["221.119.9.10","H"],
  ["210.168.246.206","H"],
  ["219.108.15.8","H"],
  ["221.119.0.217","H"],
  ["221.119.0.249","H"],
  ["221.119.8.192","H"],
  ["210.168.246.118","H"],
  ["221.119.0.146","H"],
  ["221.119.1.118","H"],
  ["221.119.0.112","H"],
  ["61.198.249.251","H"],
  ["221.119.1.34","H"],
  ["61.198.167.237","H"],
  ["221.119.1.39","H"],
  ["221.119.1.243","H"],
  ["61.198.253.215","H"],
  ["61.198.167.132","H"],
  ["61.198.253.242","H"],
  ["221.119.0.208","H"],
  ["61.198.249.205","H"],
  ["61.198.249.95","H"],
  ["221.119.1.254","H"],
  ["210.168.246.27","H"],
  ["221.119.3.58","H"],
  ["221.119.2.14","H"],
  ["221.119.9.39","H"],
  ["221.119.2.39","H"],
  ["210.168.247.31","H"],
  ["221.119.2.76","H"],
  ["61.198.167.217","H"],
  ["210.168.246.190","H"],
  ["210.168.246.36","H"],
  ["221.119.3.219","H"],
  ["221.119.3.43","H"],
  ["219.108.15.24","H"],
  ["61.198.249.55","H"],
  ["221.119.1.61","H"],
  ["210.168.247.2","H"],
  ["210.168.247.153","H"],
  ["221.119.8.138","H"],
  ["221.119.8.203","H"],
  ["221.119.8.238","H"],
  ["221.119.0.191","H"],
  ["221.119.8.249","H"],
  ["210.168.246.162","H"],
  ["221.119.8.14","H"],
  ["61.198.249.69","H"],
  ["61.198.249.244","H"],
  ["61.198.249.113","H"],
  ["61.198.249.8","H"],
  ["221.119.8.205","H"],
  ["221.119.1.169","H"],
  ["61.198.250.110","H"],
  ["221.119.1.43","H"],
  ["221.119.1.253","H"],
  ["61.198.250.162","H"],
  ["221.119.9.103","H"],
  ["221.119.0.108","H"],
  ["210.168.246.82","H"],
  ["210.168.246.238","H"],
  ["221.119.8.85","H"],
  ["61.198.249.128","H"],
  ["221.119.9.136","H"],
  ["61.198.249.215","H"],
  ["210.168.246.237","H"],
  ["61.198.249.158","H"],
  ["221.119.8.83","H"],
  ["221.119.1.167","H"],
  ["219.108.15.49","H"],
  ["221.119.0.126","H"],
  ["210.168.246.117","H"],
  ["61.198.167.9","H"],
  ["221.119.1.129","H"],
  ["61.198.250.120","H"],
  ["221.119.1.101","H"],
  ["61.198.167.87","H"],
  ["61.198.249.61","H"],
  ["221.119.8.161","H"],
  ["221.119.2.56","H"],
  ["221.119.3.178","H"],
  ["221.119.2.36","H"],
  ["221.119.1.242","H"],
  ["221.119.2.243","H"],
  ["221.119.0.149","H"],
  ["61.198.250.145","H"],
  ["61.198.250.159","H"],
  ["61.198.249.200","H"],
  ["61.198.249.238","H"],
  ["221.119.8.212","H"],
  ["61.198.250.244","H"],
  ["61.198.250.68","H"],
  ["221.119.9.237","H"],
  ["210.168.247.167","H"],
  ["221.119.1.27","H"],
  ["221.119.2.194","H"],
  ["221.119.8.227","H"],
  ["221.119.1.201","H"],
  ["61.198.249.112","H"],
  ["221.119.8.218","H"],
  ["221.119.0.109","H"],
  ["61.198.253.240","H"],
  ["221.119.2.28","H"],
  ["221.119.1.150","H"],
  ["61.198.167.15","H"],
  ["61.198.253.145","H"],
  ["221.119.9.159","H"],
  ["219.108.15.127","H"],
  ["221.119.3.192","H"],
  ["221.119.3.76","H"],
  ["221.119.3.130","H"],
  ["61.198.250.174","H"],
  ["210.168.246.71","H"],
  ["221.119.3.188","H"],
  ["221.119.1.223","H"],
  ["221.119.8.201","H"],
  ["61.198.249.243","H"],
  ["210.168.246.108","H"],
  ["61.198.249.10","H"],
  ["61.198.249.3","H"],
  ["61.198.253.154","H"],
  ["221.119.0.150","H"],
  ["221.119.0.242","H"],
  ["221.119.0.252","H"],
  ["61.198.249.12","H"],
  ["210.168.246.120","H"],
  ["61.198.250.111","H"],
  ["61.198.250.214","H"],
  ["221.119.8.11","H"],
  ["221.119.0.167","H"],
  ["221.119.1.130","H"],
  ["221.119.3.250","H"],
  ["221.119.1.35","H"],
  ["221.119.0.100","H"],
  ["221.119.8.182","H"],
  ["221.119.2.230","H"],
  ["61.198.167.86","H"],
  ["61.198.167.99","H"],
  ["61.198.249.66","H"],
  ["61.198.253.174","H"],
  ["221.119.9.47","H"],
  ["221.119.2.123","H"],
  ["221.119.8.245","H"],
  ["219.108.15.31","H"],
  ["221.119.0.71","H"],
  ["221.119.1.59","H"],
  ["221.119.3.157","H"],
  ["221.119.2.84","H"],
  ["61.198.253.191","H"],
  ["219.108.15.71","H"],
  ["210.168.247.108","H"],
  ["221.119.8.60","H"],
  ["221.119.1.85","H"],
  ["221.119.8.236","H"],
  ["210.168.246.149","H"],
  ["210.168.246.204","H"],
  ["221.119.3.179","H"],
  ["221.119.8.199","H"],
  ["221.119.9.27","H"],
  ["61.198.253.133","H"],
  ["210.168.246.35","H"],
  ["221.119.1.135","H"],
  ["221.119.8.189","H"],
  ["221.119.2.93","H"],
  ["221.119.8.35","H"],
  ["221.119.0.129","H"],
  ["61.198.249.82","H"],
  ["61.198.249.106","H"],
  ["61.198.249.126","H"],
  ["221.119.1.68","H"],
  ["221.119.0.223","H"],
  ["219.108.15.38","H"],
  ["221.119.8.172","H"],
  ["221.119.8.171","H"],
  ["61.198.167.141","H"],
  ["221.119.9.67","H"],
  ["221.119.8.45","H"],
  ["61.198.167.193","H"],
  ["221.119.2.91","H"],
  ["221.119.1.1","H"],
  ["221.119.0.174","H"],
  ["221.119.2.101","H"],
  ["221.119.1.199","H"],
  ["61.198.249.70","H"],
  ["61.198.250.26","H"],
  ["221.119.3.193","H"],
  ["219.108.15.135","H"],
  ["61.198.249.19","H"],
  ["61.198.250.78","H"],
  ["221.119.1.137","H"],
  ["210.168.246.241","H"],
  ["221.119.1.155","H"],
  ["61.198.167.173","H"],
  ["221.119.0.19","H"],
  ["221.119.0.241","H"],
  ["210.168.246.75","H"],
  ["221.119.1.11","H"],
  ["221.119.0.210","H"],
  ["221.119.2.40","H"],
  ["221.119.1.106","H"],
  ["210.168.247.176","H"],
  ["61.198.249.75","H"],
  ["221.119.9.99","H"],
  ["61.198.167.67","H"],
  ["210.168.247.80","H"],
  ["219.108.15.137","H"],
  ["61.198.253.221","H"],
  ["221.119.8.98","H"],
  ["221.119.9.188","H"],
  ["221.119.2.52","H"],
  ["221.119.8.80","H"],
  ["221.119.0.194","H"],
  ["221.119.8.204","H"],
  ["210.168.246.145","H"],
  ["221.119.3.37","H"],
  ["210.168.246.194","H"],
  ["221.119.8.223","H"],
  ["221.119.3.152","H"],
  ["61.198.253.130","H"],
  ["221.119.8.248","H"],
  ["221.119.0.213","H"],
  ["61.198.253.230","H"],
  ["210.168.247.252","H"],
  ["61.198.167.19","H"],
  ["61.198.253.197","H"],
  ["61.198.253.148","H"],
  ["221.119.8.48","H"],
  ["221.119.8.63","H"],
  ["210.168.247.6","H"],
  ["61.198.249.155","H"],
  ["221.119.9.35","H"],
  ["61.198.253.187","H"],
  ["221.119.3.35","H"],
  ["219.108.15.22","H"],
  ["61.198.167.14","H"],
  ["221.119.0.202","H"],
  ["221.119.8.26","H"],
  ["221.119.2.19","H"],
  ["221.119.2.57","H"],
  ["61.198.167.51","H"],
  ["221.119.3.20","H"],
  ["221.119.8.43","H"],
  ["61.198.167.46","H"],
  ["221.119.2.182","H"],
  ["210.168.246.125","H"],
  ["221.119.2.89","H"],
  ["221.119.8.59","H"],
  ["61.198.253.164","H"],
  ["210.168.247.127","H"],
  ["61.198.249.176","H"],
  ["61.198.249.91","H"],
  ["210.168.246.126","H"],
  ["221.119.1.107","H"],
  ["221.119.1.2","H"],
  ["221.119.1.67","H"],
  ["221.119.8.15","H"],
  ["221.119.3.15","H"],
  ["61.198.167.5","H"],
  ["221.119.1.30","H"],
  ["61.198.253.236","H"],
  ["61.198.249.170","H"],
  ["221.119.0.188","H"],
  ["61.198.167.83","H"],
  ["221.119.0.189","H"],
  ["210.168.246.32","H"],
  ["221.119.1.22","H"],
  ["221.119.9.217","H"],
  ["210.168.246.157","H"],
  ["61.198.249.50","H"],
  ["221.119.9.122","H"],
  ["221.119.9.29","H"],
  ["221.119.2.12","H"],
  ["221.119.2.43","H"],
  ["61.198.253.194","H"],
  ["210.168.247.126","H"],
  ["61.198.167.62","H"],
  ["61.198.167.36","H"],
  ["221.119.9.55","H"],
  ["221.119.0.84","H"],
  ["219.108.15.48","H"],
  ["221.119.8.57","H"],
  ["61.198.249.202","H"],
  ["221.119.8.247","H"],
  ["221.119.0.222","H"],
  ["219.108.15.75","H"],
  ["61.198.253.138","H"],
  ["221.119.2.74","H"],
  ["210.168.246.243","H"],
  ["210.168.246.58","H"],
  ["221.119.9.5","H"],
  ["221.119.9.63","H"],
  ["219.108.15.18","H"],
  ["221.119.2.116","H"],
  ["221.119.2.198","H"],
  ["61.198.250.157","H"],
  ["221.119.1.209","H"],
  ["219.108.15.50","H"],
  ["221.119.1.144","H"],
  ["219.108.15.111","H"],
  ["210.168.247.66","H"],
  ["221.119.9.208","H"],
  ["221.119.9.7","H"],
  ["221.119.0.73","H"],
  ["210.168.246.31","H"],
  ["221.119.1.229","H"],
  ["219.108.15.114","H"],
  ["221.119.8.121","H"],
  ["61.198.249.21","H"],
  ["61.198.167.223","H"],
  ["61.198.167.192","H"],
  ["61.198.249.108","H"],
  ["221.119.0.93","H"],
  ["221.119.1.237","H"],
  ["221.119.8.188","H"],
  ["221.119.0.227","H"],
  ["61.198.250.229","H"],
  ["210.168.246.47","H"],
  ["221.119.1.186","H"],
  ["221.119.0.101","H"],
  ["221.119.8.16","H"],
  ["61.198.249.168","H"],
  ["61.198.167.172","H"],
  ["210.168.246.73","H"],
  ["210.168.247.159","H"],
  ["210.168.246.52","H"],
  ["61.198.249.222","H"],
  ["210.168.246.5","H"],
  ["61.198.249.225","H"],
  ["210.168.247.13","H"],
  ["221.119.9.161","H"],
  ["210.168.247.89","H"],
  ["221.119.3.74","H"],
  ["61.198.249.188","H"],
  ["210.168.246.148","H"],
  ["61.198.249.224","H"],
  ["221.119.1.111","H"],
  ["61.198.167.28","H"],
  ["210.168.247.33","H"],
  ["61.198.249.241","H"],
  ["61.198.250.254","H"],
  ["221.119.8.150","H"],
  ["61.198.249.148","H"],
  ["221.119.1.211","H"],
  ["210.168.247.35","H"],
  ["61.198.167.120","H"],
  ["210.168.246.77","H"],
  ["210.168.246.12","H"],
  ["221.119.3.10","H"],
  ["219.108.15.83","H"],
  ["221.119.3.131","H"],
  ["221.119.1.75","H"],
  ["61.198.253.160","H"],
  ["61.198.167.43","H"],
  ["61.198.249.217","H"],
  ["61.198.249.99","H"],
  ["210.168.246.198","H"],
  ["61.198.250.6","H"],
  ["61.198.250.190","H"],
  ["61.198.249.64","H"],
  ["61.198.249.123","H"],
  ["219.108.15.9","H"],
  ["61.198.249.117","H"],
  ["210.168.247.172","H"],
  ["61.198.167.127","H"],
  ["61.198.250.4","H"],
  ["210.168.247.244","H"],
  ["61.198.253.244","H"],
  ["210.168.246.169","H"],
  ["61.198.249.178","H"],
  ["221.119.2.221","H"],
  ["221.119.3.57","H"],
  ["219.108.15.88","H"],
  ["210.168.247.168","H"],
  ["221.119.1.142","H"],
  ["61.198.250.158","H"],
  ["210.168.246.85","H"],
  ["210.168.246.225","H"],
  ["221.119.8.224","H"],
  ["221.119.9.117","H"],
  ["221.119.0.11","H"],
  ["61.198.249.194","H"],
  ["219.108.15.81","H"],
  ["210.168.247.231","H"],
  ["61.198.250.194","H"],
  ["219.108.15.151","H"],
  ["221.119.3.122","H"],
  ["210.168.246.220","H"],
  ["61.198.253.171","H"],
  ["61.198.249.218","H"],
  ["219.108.15.146","H"],
  ["210.168.246.189","H"],
  ["221.119.9.90","H"],
  ["221.119.9.156","H"],
  ["221.119.2.77","H"],
  ["210.168.247.241","H"],
  ["219.108.15.37","H"],
  ["221.119.1.74","H"],
  ["61.198.250.179","H"],
  ["221.119.1.146","H"],
  ["61.198.167.122","H"],
  ["219.108.15.20","H"],
  ["219.108.15.105","H"],
  ["221.119.9.212","H"],
  ["221.119.9.80","H"],
  ["61.198.249.73","H"],
  ["61.198.253.151","H"],
  ["221.119.1.190","H"],
  ["221.119.0.99","H"],
  ["61.198.249.187","H"],
  ["61.198.167.107","H"],
  ["221.119.1.184","H"],
  ["210.168.246.45","H"],
  ["221.119.1.218","H"],
  ["221.119.1.198","H"],
  ["210.168.246.202","H"],
  ["61.198.250.154","H"],
  ["221.119.8.30","H"],
  ["221.119.1.50","H"],
  ["219.108.15.94","H"],
  ["210.168.246.115","H"],
  ["221.119.3.240","H"],
  ["61.198.253.223","H"],
  ["221.119.1.163","H"],
  ["221.119.2.186","H"],
  ["221.119.0.183","H"],
  ["221.119.9.241","H"],
  ["210.168.246.97","H"],
  ["61.198.250.241","H"],
  ["61.198.167.249","H"],
  ["61.198.250.14","H"],
  ["61.198.253.135","H"],
  ["210.168.247.47","H"],
  ["61.198.249.130","H"],
  ["61.198.250.41","H"],
  ["61.198.250.171","H"],
  ["61.198.167.200","H"],
  ["61.198.250.178","H"],
  ["61.198.250.131","H"],
  ["61.198.253.128","H"],
  ["221.119.1.132","H"],
  ["61.198.250.104","H"],
  ["210.168.247.5","H"],
  ["219.108.15.165","H"],
  ["221.119.0.102","H"],
  ["211.8.159.185","V"],
  ["211.8.159.186","V"],
  ["211.8.159.131","V"],
  ["211.8.159.133","V"],
  ["211.8.159.136","V"],
  ["211.8.159.134","V"],
  ["210.146.60.207","V"],
  ["210.146.60.208","V"],
  ["211.127.183.51","V"],
  ["211.127.183.50","V"],
  ["211.8.159.135","V"],
  ["211.8.159.132","V"],
  ["210.146.60.199","V"],
  ["210.169.193.231","V"],
  ["210.169.193.230","V"],
  ["210.169.193.225","V"],
  ["210.169.193.224","V"],
  ["210.228.189.32","V"],
  ["210.228.189.33","V"],
  ["211.8.49.162","V"],
  ["210.134.83.49","V"],
  ["211.8.49.161","V"],
  ["210.134.83.50","V"],
  ["210.228.189.34","V"],
  ["210.228.189.77","V"],
  ["210.136.161.136","I"],
  ["210.136.161.165","I"],
  ["210.153.84.204","I"],
  ["210.136.161.132","I"],
  ["210.136.161.169","I"],
  ["210.153.84.202","I"],
  ["210.136.161.134","I"],
  ["210.136.161.131","I"],
  ["210.136.161.163","I"],
  ["210.153.84.228","I"],
  ["210.153.84.230","I"],
  ["210.153.84.194","I"],
  ["210.153.84.203","I"],
  ["210.153.84.195","I"],
  ["210.153.84.231","I"],
  ["210.136.161.194","I"],
  ["210.136.161.235","I"],
  ["210.136.161.199","I"],
  ["210.136.161.228","I"],
  ["210.136.161.204","I"],
  ["210.136.161.225","I"],
  ["210.136.161.230","I"],
  ["210.136.161.226","I"],
  ["210.153.84.232","I"],
  ["210.153.84.198","I"],
  ["210.153.84.234","I"],
  ["210.153.84.197","I"],
  ["210.153.84.206","I"],
  ["210.153.84.236","I"],
  ["210.153.84.205","I"],
  ["210.153.84.200","I"],
  ["210.136.161.232","I"],
  ["210.136.161.196","I"],
  ["210.153.84.238","I"],
  ["210.153.84.237","I"],
  ["210.153.84.226","I"],
  ["210.153.84.235","I"],
  ["210.153.84.227","I"],
  ["210.153.84.233","I"],
  ["210.153.84.225","I"],
  ["210.136.161.227","I"],
  ["210.136.161.166","I"],
  ["210.153.84.196","I"],
  ["210.136.161.137","I"],
  ["210.153.84.199","I"],
  ["210.136.161.195","I"],
  ["210.136.161.198","I"],
  ["210.136.161.202","I"],
  ["210.136.161.197","I"],
  ["210.153.84.201","I"],
  ["210.136.161.170","I"],
  ["210.136.161.130","I"],
  ["210.136.161.162","I"],
  ["210.136.161.138","I"],
  ["210.136.161.135","I"],
  ["210.136.161.161","I"],
  ["210.136.161.133","I"],
  ["210.136.161.167","I"],
  ["210.136.161.129","I"],
  ["210.136.161.233","I"],
  ["210.153.84.229","I"],
  ["210.153.84.193","I"],
  ["210.136.161.201","I"],
  ["210.136.161.193","I"],
  ["210.136.161.229","I"],
  ["210.136.161.200","I"],
  ["210.136.161.231","I"],
  ["210.136.161.234","I"],
  ["210.136.161.203","I"],
  ["210.136.161.236","I"],
  ["210.136.161.168","I"],
  ["210.136.161.164","I"],
);

for (@Tests) {
  local *ENV = {HTTP_USER_AGENT => $_};
  my $ua = HTTP::MobileAgent->new;
  foreach my $ip (@IPS) {
    my $carrier = $ip->[1];
    if (($ua->carrier =~ /$carrier/) || ($carrier eq 'N'))
    {
      ok $ua->check_network($ip->[0]);
    }
    else
    {
      ok !($ua->check_network($ip->[0]));
    }
  }
}


# Changelog

## v0.3.3
- Bump aliyun_util from 0.3.1 to 0.3.3
- Bump ex_doc from 0.19.3 to 0.20.3

## v0.3.2
- Ammend doc of example usage

## v0.3.1
- Improve docs

## v0.3.0
- New APIs(Complete Bucket and Object):
  - Put Bucket Website
  - Put Bucket Referer
  - Delete Bucket Website
  - Delete Bucket Lifecycle
  - Put Object
  - Put Symlink
  - Get Symlink
  - Restore Object
  - Append Object
  - Copy Object
  - Put Object ACL
  - Delete Object
  - Delete Multiple Objects
  - Sign Post Object Policy
- Fixes
  - doc of `Bucket.put_bucket_logging/3`

## v0.2.1
- New APIs:
  - generate signed object URL
  - Put Bucket	创建Bucket
  - Put Bucket ACL	设置Bucket访问权限
  - Put Bucket Logging	开启Bucket日志
  - Delete Bucket	删除Bucket
  - Delete Bucket Logging	关闭Bucket访问日志记录功能

## v0.2.0
- New response struct
- New error struct
- New APIs:
  - Get Object
  - Get Object Acl
  - Get Object Meta

## v0.1.0
- Get Bucket Acl	获得Bucket访问权限
- Get Bucket Location	获得Bucket所属的数据中心位置信息
- Get Bucket Logging	查看Bucket的访问日志配置情况
- Get Bucket Website	查看Bucket的静态网站托管状态
- Get Bucket Referer	查看Bucket的防盗链规则
- Get Bucket Lifecycle	查看Bucket中Object的生命周期规则
- Get Bucket(List Object)	获得Bucket中所有Object的信息
- Get Bucket Info	获取Bucket信息
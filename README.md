# AliyunOss

[![Build Status](https://travis-ci.org/ug0/aliyun_oss.svg?branch=master)](https://travis-ci.org/ug0/aliyun_oss)
[![Hex.pm](https://img.shields.io/hexpm/v/aliyun_oss.svg)](https://hex.pm/packages/aliyun_oss)

阿里云对象存储（OSS）API

## Installation

Add `aliyun_oss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aliyun_oss, "~> 0.6.2"}
  ]
end
```


## Configuration
```elixir
config :aliyun_oss,
  endpoint: "oss-cn-shenzhen.aliyuncs.com",
  access_key_id: "ALIYUN_ACCESS_KEY_ID",
  access_key_secret: "ALIYUN_ACCESS_KEY_SECRET"
```
Or if you want to config them via run-time system environment variables:
```elixir
config :aliyun_oss,
  endpoint: {:system, "ALIYUN_ENDPOINT"},
  access_key_id: {:system, "ALIYUN_ACCESS_KEY_ID"},
  access_key_secret: {:system, "ALIYUN_ACCESS_KEY_SECRET"}
```

## Documentation
[https://hexdocs.pm/aliyun_oss](https://hexdocs.pm/aliyun_oss)


### API List

参考[阿里云官方文档](https://help.aliyun.com/document_detail/31948.html?spm=a2c4g.11186623.6.1037.520869cbKcHFcL)

- [x] **Service**

  - [x] GetService	得到该账户下所有Bucket

- [x] Bucket

  - [x] Put Bucket	创建Bucket
  - [x] Put Bucket ACL	设置Bucket访问权限
  - [x] Put Bucket Logging	开启Bucket日志
  - [x] Put Bucket Website	设置Bucket为静态网站托管模式
  - [x] Put Bucket Referer	设置Bucket的防盗链规则
  - [x] Put Bucket Lifecycle	设置Bucket中Object的生命周期规则
  - [x] Get Bucket Acl	获得Bucket访问权限
  - [x] Get Bucket Location	获得Bucket所属的数据中心位置信息
  - [x] Get Bucket Logging	查看Bucket的访问日志配置情况
  - [x] Get Bucket Website	查看Bucket的静态网站托管状态
  - [x] Get Bucket Referer	查看Bucket的防盗链规则
  - [x] Get Bucket Lifecycle	查看Bucket中Object的生命周期规则
  - [x] Delete Bucket	删除Bucket
  - [x] Delete Bucket Logging	关闭Bucket访问日志记录功能
  - [x] Delete Bucket Website	关闭Bucket的静态网站托管模式
  - [x] Delete Bucket Lifecycle	删除Bucket中Object的生命周期规则
  - [x] Get Bucket(List Object)	获得Bucket中所有Object的信息
  - [x] Get Bucket Info	获取Bucket信息
  - [x] PutBucketEncryption	配置Bucket的加密规则
  - [x] GetBucketEncryption	获取Bucket的加密规则
  - [x] DeleteBucketEncryption	删除Bucket的加密规则

- [x] Object

  - [x] Put Object	上传object
  - [x] Copy Object	拷贝一个object成另外一个object
  - [x] Get Object	获取Object
  - [x] Delete Object	删除Object
  - [x] Delete Multiple Objects	删除多个Object
  - [x] Head Object	获得Object的meta信息
  - [x] Sign Post Policy	生成 Post Policy 签名
  - [x] Append Object	在Object尾追加上传数据
  - [x] Put Object ACL	设置Object ACL
  - [x] Get Object ACL	获取Object ACL信息
  - [x] Callback	上传回调
  - [x] PutSymlink	创建软链接
  - [x] GetSymlink	获取软链接
  - [x] RestoreObject	解冻文件
  - [x] Generate signed URL 生成包含签名的 URL
  - [ ] SelectObject	用SQL语法查询Object内容
  - [x] PutObjectTagging	设置或更新对象标签
  - [x] GetObjectTagging	获取对象标签信息
  - [x] DeleteObjectTagging	删除指定的对象标签


- [x] Multipart Upload
  - [x] Initiate Multipart Upload	初始化 MultipartUpload 事件
  - [x] Upload Part	分块上传文件
  - [x] Upload Part Copy	分块复制上传文件
  - [x] Complete Multipart Upload	完成整个文件的 Multipart Upload 上传
  - [x] Abort Multipart Upload	取消 Multipart Upload 事件
  - [x] List Multipart Uploads	罗列出所有执行中的 Multipart Upload 事件
  - [x] List Parts	罗列出指定 Upload ID 所属的所有已经上传成功 Part


- [ ] CORS
  - [ ] Put Bucket cors	在指定Bucket设定一个CORS的规则
  - [ ] Get Bucket cors	获取指定的Bucket目前的CORS规则
  - [ ] Delete Bucket cors	关闭指定Bucket对应的CORS功能并清空所有规则
  - [ ] Option Object	跨域访问preflight请求

- [ ] live Channel
  - [ ] PutLiveChannelStatus	切换LiveChannel的状态
  - [ ] PutLiveChannel	创建LiveChannel
  - [ ] GetVodPlaylist	获取播放列表
  - [ ] PostVodPlaylist	生成播放列表
  - [ ] Get LiveChannelStat	获取LiveChannel的推流状态信息
  - [ ] GetLiveChannelInfo	获取LiveChannel的配置信息
  - [ ] GetLiveChannelHistory	获取LiveChannel的推流记录
  - [ ] ListLiveChannel	列举LiveChannel
  - [ ] DeleteLiveChannel	删除LiveChannel

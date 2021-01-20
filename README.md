# AliyunOss

[![Build Status](https://travis-ci.org/ug0/aliyun_oss.svg?branch=master)](https://travis-ci.org/ug0/aliyun_oss)
[![Hex.pm](https://img.shields.io/hexpm/v/aliyun_oss.svg)](https://hex.pm/packages/aliyun_oss)

阿里云对象存储（OSS）API

## Installation

Add `aliyun_oss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aliyun_oss, "~> 0.6.3"}
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

更多请参考[阿里云官方文档](https://help.aliyun.com/document_detail/31948.html?spm=a2c4g.11186623.6.1037.520869cbKcHFcL)

**关于Bucket的操作**
  - [x] PutBucket	创建Bucket
  - [x] DeleteBucket	删除Bucket
  - [x] GetBucket(ListObjects)	获得Bucket中所有Object的信息
  - [x] GetBucketInfo	获取Bucket信息
  - [x] GetBucketLocation	获得Bucket所属的数据中心位置信息
  - [x] PutBucketACL	设置Bucket访问权限
  - [x] GetBucketAcl	获得Bucket访问权限
  - [x] PutBucketLifecycle	设置Bucket中Object的生命周期规则
  - [x] GetBucketLifecycle	查看Bucket中Object的生命周期规则
  - [x] DeleteBucketLifecycle	删除Bucket中Object的生命周期规则
  - [x] PutBucketVersioning	设置Bucket的版本控制状态
  - [x] GetBucketVersioning	获取Bucket的版本控制状态
  - [x] GetBucketVersions(ListObjectVersions)	列举Bucket中所有Object的版本信息
  - [x] PutBucketReplication	设置Bucket的跨区域复制规则
  - [x] GetBucketReplication	查看Bucket已设置的跨区域复制规则
  - [x] GetBucketReplicationLocation	查看可复制到的目标Bucket所在的地域
  - [x] GetBucketReplicationProgress	查看Bucket的跨区域复制进度
  - [x] DeleteBucketReplication	停止Bucket的跨区域复制任务并删除Bucket的复制配置
  - [x] PutBucketPolicy	设置Bucket Policy
  - [x] GetBucketPolicy	获取Bucket Policy
  - [x] DeleteBucketPolicy	删除Bucket Policy
  - [x] PutBucketInventory	设置Bucket清单规则
  - [x] GetBucketInventory	查看Bucket中指定的清单任务
  - [x] ListBucketInventory	查看Bucket中所有的清单任务
  - [x] DeleteBucketInventory	删除Bucket中指定的清单任务
  - [x] InitiateBucketWorm	新建合规保留策略
  - [x] AbortBucketWorm	删除未锁定的合规保留策略
  - [x] CompleteBucketWorm	锁定合规保留策略
  - [x] ExtendBucketWorm	延长已锁定的合规保留策略对应Bucket中Object的保留天数
  - [x] GetBucketWorm	查看Bucket的合规保留策略信息
  - [x] PutBucketLogging	开启Bucket访问日志记录功能
  - [x] GetBucketLogging	查看Bucket的访问日志配置情况
  - [x] DeleteBucketLogging	关闭Bucket访问日志记录功能
  - [x] PutBucketWebsite	设置Bucket为静态网站托管模式
  - [x] GetBucketWebsite	查看Bucket的静态网站托管状态
  - [x] DeleteBucketWebsite	关闭Bucket的静态网站托管模式
  - [x] PutBucketReferer	设置Bucket的防盗链规则
  - [x] GetBucketReferer	查看Bucket的防盗链规则
  - [x] PutBucketTags	添加或修改Bucket标签
  - [x] GetBucketTags	查看Bucket标签信息
  - [x] DeleteBucketTags	删除Bucket标签
  - [x] PutBucketEncryption	配置Bucket的加密规则
  - [x] GetBucketEncryption	获取Bucket的加密规则
  - [x] DeleteBucketEncryption	删除Bucket的加密规则
  - [x] PutBucketRequestPayment	设置Bucket为请求者付费模式
  - [x] GetBucketRequestPayment	查看Bucket请求者付费模式配置信息

**关于Object的操作**

  - [x] PutObject	上传object
  - [x] CopyObject	拷贝一个object成另外一个object
  - [x] GetObject	获取Object
  - [x] AppendObject	在Object尾追加上传数据
  - [x] DeleteObject	删除Object
  - [x] DeleteMultipleObjects	删除多个Object
  - [x] HeadObject	只返回某个Object的meta信息，不返回文件内容
  - [x] GetObjectMeta	返回Object的基本meta信息，包括该Object的ETag、Size（文件大小）以及LastModified等，不返回文件内容
  - [x] SignPostPolicy	生成 Post Policy 签名
  - [x] PutObjectACL	设置Object ACL
  - [x] GetObjectACL	获取Object ACL信息
  - [x] Callback	上传回调
  - [x] PutSymlink	创建软链接
  - [x] GetSymlink	获取软链接
  - [x] RestoreObject	解冻文件
  - [x] SelectObject	用SQL语法查询Object内容
  - [x] GeneratesignedURL 生成包含签名的 URL
  - [x] PutObjectTagging	设置或更新对象标签
  - [x] GetObjectTagging	获取对象标签信息
  - [x] DeleteObjectTagging	删除指定的对象标签


**关于Multipart Upload的操作**

  - [x] InitiateMultipartUpload	初始化MultipartUpload事件
  - [x] UploadPart	分块上传文件
  - [x] UploadPartCopy	分块复制上传文件
  - [x] CompleteMultipartUpload	完成整个文件的MultipartUpload上传
  - [x] AbortMultipartUpload	取消MultipartUpload事件
  - [x] ListMultipartUploads	列举所有执行中的MultipartUpload事件
  - [x] ListParts	列举指定UploadID所属的所有已上传成功的Part


**跨域资源共享（CORS）**
  - [x] PutBucketcors	在指定Bucket设定一个CORS的规则
  - [x] GetBucketcors	获取指定的Bucket目前的CORS规则
  - [x] DeleteBucketcors	关闭指定Bucket对应的CORS功能并清空所有规则

**关于Live Channel的操作**
  - [ ] PutLiveChannelStatus	切换LiveChannel的状态
  - [ ] PutLiveChannel	创建LiveChannel
  - [ ] GetVodPlaylist	获取播放列表
  - [ ] PostVodPlaylist	生成播放列表
  - [ ] Get LiveChannelStat	获取LiveChannel的推流状态信息
  - [ ] GetLiveChannelInfo	获取LiveChannel的配置信息
  - [ ] GetLiveChannelHistory	获取LiveChannel的推流记录
  - [ ] ListLiveChannel	列举LiveChannel
  - [ ] DeleteLiveChannel	删除LiveChannel

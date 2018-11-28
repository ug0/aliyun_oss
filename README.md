# AliyunOss

阿里云对象存储（OSS）API

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aliyun_oss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aliyun_oss, "~> 0.1.0"}
  ]
end
```

## Roadmap

### Official Interfaces
[参考阿里云官方文档](https://help.aliyun.com/document_detail/31948.html?spm=a2c4g.11186623.6.1037.520869cbKcHFcL)

- [x] **Service**

  - [x] GetService	得到该账户下所有Bucket

- Bucket

  - [ ] Put Bucket	创建Bucket
  - [ ] Put Bucket ACL	设置Bucket访问权限
  - [ ] Put Bucket Logging	开启Bucket日志
  - [ ] Put Bucket Website	设置Bucket为静态网站托管模式
  - [ ] Put Bucket Referer	设置Bucket的防盗链规则
  - [ ] Put Bucket Lifecycle	设置Bucket中Object的生命周期规则
  - [ ] Get Bucket Acl	获得Bucket访问权限
  - [ ] Get Bucket Location	获得Bucket所属的数据中心位置信息
  - [ ] Get Bucket Logging	查看Bucket的访问日志配置情况
  - [ ] Get Bucket Website	查看Bucket的静态网站托管状态
  - [ ] Get Bucket Referer	查看Bucket的防盗链规则
  - [ ] Get Bucket Lifecycle	查看Bucket中Object的生命周期规则
  - [ ] Delete Bucket	删除Bucket
  - [ ] Delete Bucket Logging	关闭Bucket访问日志记录功能
  - [ ] Delete Bucket Website	关闭Bucket的静态网站托管模式
  - [ ] Delete Bucket Lifecycle	删除Bucket中Object的生命周期规则
  - [x] Get Bucket(List Object)	获得Bucket中所有Object的信息
  - [ ] Get Bucket Info	获取Bucket信息

- [ ] Object

  - [ ] Put Object	上传object
  - [ ] Copy Object	拷贝一个object成另外一个object
  - [ ] Get Object	获取Object
  - [ ] Delete Object	删除Object
  - [ ] Delete Multiple Objects	删除多个Object
  - [ ] Head Object	获得Object的meta信息
  - [ ] Post Object	使用Post上传Object
  - [ ] Append Object	在Object尾追加上传数据
  - [ ] Put Object ACL	设置Object ACL
  - [ ] Get Object ACL	获取Object ACL信息
  - [ ] Callback	上传回调


- [ ] Multipart Upload

  - [ ] Initiate Multipart Upload	初始化MultipartUpload事件
  - [ ] Upload Part	分块上传文件
  - [ ] Upload Part Copy	分块复制上传文件
  - [ ] Complete Multipart Upload	完成整个文件的Multipart Upload上传
  - [ ] Abort Multipart Upload	取消Multipart Upload事件
  - [ ] List Multipart Uploads	罗列出所有执行中的Multipart Upload事件
  - [ ] List Parts	罗列出指定Upload ID所属的所有已经上传成功Part


- [ ] CORS
  - [ ] Put Bucket cors	在指定Bucket设定一个CORS的规则
  - [ ] Get Bucket cors	获取指定的Bucket目前的CORS规则
  - [ ] Delete Bucket cors	关闭指定Bucket对应的CORS功能并清空所有规则
  - [ ] Option Object	跨域访问preflight请求

### Documentation(WIP)
[https://hexdocs.pm/aliyun_oss](https://hexdocs.pm/aliyun_oss)

### Improvements
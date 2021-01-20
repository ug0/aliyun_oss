# Changelog

## v0.7.0(WIP)
  - **Breaking changes**:
    - Use separated modules to scope SubResources of Bucket/Object, for example:
      - `Aliyun.Oss.Bucket.get_acl` becomes `Aliyun.Oss.Bucket.ACL.get`
      - `Aliyun.Oss.Object.get_acl` becomes `Aliyun.Oss.Object.ACL.get`
  - Update dependencies
  - New APIs:
    - GetBucketV2 (ListObjectsV2): `Aliyun.Oss.Bucket.list_objects`
    - GetObjectMeta: `Aliyun.Oss.Object.get_object_meta`
    - PutBucketLifecycle: `Aliyun.Oss.Lifecycle.put`
    - SelectObject: `Aliyun.Oss.Object.select_object`
    - CreateSelectObjectMeta: `Aliyun.Oss.Object.select_object_meta`
    - PutBucketTags: `Aliyun.Oss.Bucket.Tags.put`
    - GetBucketTags: `Aliyun.Oss.Bucket.Tags.get`
    - DeleteBucketTags: `Aliyun.Oss.Bucket.Tags.delete`
    - GetBucketRequestPayment: `Aliyun.Oss.Bucket.RequestPayment.get`
    - PutBucketRequestPayment: `Aliyun.Oss.Bucket.RequestPayment.put`
    - PutBucketPolicy: `Aliyun.Oss.Bucket.Policy.put`
    - GetBucketPolicy: `Aliyun.Oss.Bucket.Policy.get`
    - DeleteBucketPolicy: `Aliyun.Oss.Bucket.Policy.delete`
    - PutBucketInventory: `Aliyun.Oss.Bucket.Inventory.put`
    - GetBucketInventory: `Aliyun.Oss.Bucket.Inventory.get`
    - ListBucketInventory: `Aliyun.Oss.Bucket.Inventory.list`
    - DeleteBucketInventory: `Aliyun.Oss.Bucket.Inventory.delete`
    - PutBucketVersioning: `Aliyun.Oss.Bucket.Versioning.put`
    - GetBucketVersioning: `Aliyun.Oss.Bucket.Versioning.get`
    - ListObjectVersions: `Aliyun.Oss.Bucket.Versioning.list_object_versions`
    - PutBucketReplication: `Aliyun.Oss.Bucket.Replication.put`
    - GetBucketReplication: `Aliyun.Oss.Bucket.Replication.get`
    - GetBucketReplicationLocation: `Aliyun.Oss.Bucket.Replication.get_location`
    - GetBucketReplicationProgress: `Aliyun.Oss.Bucket.Replication.get_progress`
    - DeleteBucketReplication: `Aliyun.Oss.Bucket.Replication.delete`
    - InitiateBucketWorm: `Aliyun.Oss.Bucket.WORM.initiate`
    - AbortBucketWormLocation: `Aliyun.Oss.Bucket.WORM.abort`
    - CompleteBucketWormProgress: `Aliyun.Oss.Bucket.WORM.complete`
    - ExtendBucketWorm: `Aliyun.Oss.Bucket.WORM.extend`
    - GetBucketWorm: `Aliyun.Oss.Bucket.WORM.get`
    - PutBucketCors: `Aliyun.Oss.Bucket.CORS.put`
    - GetBucketCors: `Aliyun.Oss.Bucket.CORS.get`
    - DeleteBucketCors: `Aliyun.Oss.Bucket.CORS.delete`
    - PutLiveChannelStatus:	`Aliyun.Oss.LiveChannel.put_status`
    - PutLiveChannel: `Aliyun.Oss.LiveChannel.put`
    - GetVodPlaylist: `Aliyun.Oss.LiveChannel.get_playlist`
    - PostVodPlaylist: `Aliyun.Oss.LiveChannel.post_playlist`
    - Get LiveChannelStat: `Aliyun.Oss.LiveChannel.get_stat`
    - GetLiveChannelInfo:	`Aliyun.Oss.LiveChannel.get_info`
    - GetLiveChannelHistory: `Aliyun.Oss.LiveChannel.get_history`
    - ListLiveChannel: `Aliyun.Oss.LiveChannel.list`
    - DeleteLiveChannel: `Aliyun.Oss.LiveChannel.delete`

## v0.6.3
  - Use Supervised Task
  - Update HTTPoison requirement to ~> 1.7

## v0.6.2
  - Fix ssl connection issue on OTP23(also see https://github.com/edgurgel/httpoison/issues/411)

## v0.6.1
  - Add doc link to `Aliyun.Oss.Object.MultipartUpload`

## v0.6.0
  - Implement Multipart Upload(`Aliyun.Oss.Object.MultipartUpload`)
  - Some code refactoring
  - Fix docs

## v0.5.0
  - Add `Object.signed_url/6`

## v0.4.1
  - Support configs via run-time system environment variables.

## V0.4.0
- New APIs:
  - PutBucketEncryption
  - GetBucketEncryption
  - DeleteBucketEncryption
  - PutObjectTagging
  - GetObjectTagging
  - DeleteObjectTagging

## v0.3.4
- Fix documentation

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
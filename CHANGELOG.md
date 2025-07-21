# Changelog

## v3.0.0
  V3 replaced `httpoison` with `req` and rewrites the function to build request and generate signature.
  Now it supports [Aliyun OSS V4 signature](https://help.aliyun.com/zh/oss/developer-reference/guidelines-for-upgrading-v1-signatures-to-v4-signatures).

  - **Breaking changes**:
    - `Aliyun.Oss.Client.Response` has a new structure of `headers` as same as `req`.
      ```elixir
      # old
      %Aliyun.Oss.Client.Response{headers: [
        {"Server", "AliyunOSS"},
        {"Date", "Fri, 11 Jan 2019 04:35:39 GMT"},
        {"Content-Length", "0"},
        {"Connection", "keep-alive"},
        {"x-oss-request-id", "5C381D000000000000000000"},
        {"Location", "/new-bucket"},
        {"x-oss-server-time", "438"}
      ]}
      # new
      %Aliyun.Oss.Client.Response{headers: %{
        "connection" => ["keep-alive"],
        "content-length" => ["0"],
        "date" => ["Fri, 11 Jan 2019 04:35:39 GMT"],
        "location" => ["/new-bucket"],
        "server" => ["AliyunOSS"],
        "x-oss-request-id" => ["5C381D000000000000000000"],
        "x-oss-server-time" => ["438"]
      }}
      ```
    - `Aliyun.Oss.Config` now requires to also set `region`
    - Arguments such as `headers` are now passed via `options` keyword list:
      - `Aliyun.Oss.Bucket.get_bucket`
      - `Aliyun.Oss.Bucket.list_objects`
      - `Aliyun.Oss.Bucket.put_bucket`
      - `Aliyun.Oss.Bucket.delete_bucket`
      - `Aliyun.Oss.Bucket.WORM.initiate`
      - `Aliyun.Oss.Bucket.WORM.abort`
      - `Aliyun.Oss.Bucket.WORM.complete`
      - `Aliyun.Oss.Bucket.WORM.extend`
      - `Aliyun.Oss.Bucket.WORM.get`
      - `Aliyun.Oss.Bucket.ACL.get`
      - `Aliyun.Oss.Bucket.ACL.put`
      - `Aliyun.Oss.Bucket.Lifecycle.put`
      - `Aliyun.Oss.Bucket.Lifecycle.get`
      - `Aliyun.Oss.Bucket.Lifecycle.delete`
      - `Aliyun.Oss.Bucket.Versioning.put`
      - `Aliyun.Oss.Bucket.Versioning.get`
      - `Aliyun.Oss.Bucket.Versioning.list_object_versions`
      - `Aliyun.Oss.Bucket.Replication.put`
      - `Aliyun.Oss.Bucket.Replication.get`
      - `Aliyun.Oss.Bucket.Replication.get_location`
      - `Aliyun.Oss.Bucket.Replication.get_progress`
      - `Aliyun.Oss.Bucket.Replication.delete`
      - `Aliyun.Oss.Bucket.Policy.put`
      - `Aliyun.Oss.Bucket.Policy.get`
      - `Aliyun.Oss.Bucket.Policy.delete`
      - `Aliyun.Oss.Bucket.Inventory.put`
      - `Aliyun.Oss.Bucket.Inventory.get`
      - `Aliyun.Oss.Bucket.Inventory.list`
      - `Aliyun.Oss.Bucket.Inventory.delete`
      - `Aliyun.Oss.Bucket.Logging.put`
      - `Aliyun.Oss.Bucket.Logging.get`
      - `Aliyun.Oss.Bucket.Logging.delete`
      - `Aliyun.Oss.Bucket.Website.put`
      - `Aliyun.Oss.Bucket.Website.get`
      - `Aliyun.Oss.Bucket.Website.delete`
      - `Aliyun.Oss.Bucket.Referer.put`
      - `Aliyun.Oss.Bucket.Referer.get`
      - `Aliyun.Oss.Bucket.Tags.put`
      - `Aliyun.Oss.Bucket.Tags.get`
      - `Aliyun.Oss.Bucket.Tags.delete`
      - `Aliyun.Oss.Bucket.Encryption.put`
      - `Aliyun.Oss.Bucket.Encryption.get`
      - `Aliyun.Oss.Bucket.Encryption.delete`
      - `Aliyun.Oss.Bucket.RequestPayment.put`
      - `Aliyun.Oss.Bucket.RequestPayment.get`
      - `Aliyun.Oss.Bucket.CORS.put`
      - `Aliyun.Oss.Bucket.CORS.get`
      - `Aliyun.Oss.Bucket.CORS.delete`
      - `Aliyun.Oss.Object.head_object`
      - `Aliyun.Oss.Object.get_object`
      - `Aliyun.Oss.Object.select_object`
      - `Aliyun.Oss.Object.select_object_meta`
      - `Aliyun.Oss.Object.signed_url`
      - `Aliyun.Oss.Object.put_object`
      - `Aliyun.Oss.Object.copy_object`
      - `Aliyun.Oss.Object.append_object`
      - `Aliyun.Oss.Object.delete_object`
      - `Aliyun.Oss.Object.Symlink.put`
      - `Aliyun.Oss.Object.MultipartUpload.init_upload`
      - `Aliyun.Oss.Object.MultipartUpload.list_uploads`
      - `Aliyun.Oss.Object.MultipartUpload.upload_part_copy`
      - `Aliyun.Oss.Object.MultipartUpload.complete_upload`
      - `Aliyun.Oss.Object.MultipartUpload.list_parts`
  - New APIs:
    - `Aliyun.Oss.Bucket.get_bucket_stat`
    - `Aliyun.Oss.Region.describe_regions`
    - `Aliyun.Oss.Bucket.Replication.put_rtc`
    - `Aliyun.Oss.Bucket.Policy.get_status`
    - `Aliyun.Oss.Bucket.Logging.put_user_defined_log_fields_config`
    - `Aliyun.Oss.Bucket.Logging.get_user_defined_log_fields_config`
    - `Aliyun.Oss.Bucket.Logging.delete_user_defined_log_fields_config`
    - `Aliyun.Oss.Object.clean_restored_object`

## v2.0.0
  - **Breaking changes**:
    - Don't use global configuration any more
    - A new argument - `config` is added to all public functions

## v1.0.4
  - Fix error when object key contains `+`

## v1.0.3
  - Update dependencies

## v1.0.2
  - Correct function name: `Aliyun.Oss.Object.ACL.put`

## v1.0.1
  - Improve doc

## v1.0.0
  - **Breaking changes**:
    - Use separated modules to scope SubResources of Bucket/Object, for example:
      - `Aliyun.Oss.Bucket.get_acl` becomes `Aliyun.Oss.Bucket.ACL.get`
      - `Aliyun.Oss.Object.get_acl` becomes `Aliyun.Oss.Object.ACL.get`
  - Update dependencies
  - New APIs:
    - Bucket:
      - GetBucketV2 (ListObjectsV2): `Aliyun.Oss.Bucket.list_objects`
      - PutBucketLifecycle: `Aliyun.Oss.Bucket.Lifecycle.put`
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
    - Object:
      - GetObjectMeta: `Aliyun.Oss.Object.get_object_meta`
      - SelectObject: `Aliyun.Oss.Object.select_object`
      - CreateSelectObjectMeta: `Aliyun.Oss.Object.select_object_meta`
    - LiveChannel:
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

# 基于Ubuntu的DLNA音频推送播放服务

```
docker run -d \
--name <container name> \
-e UPNP_DEVICE_NAME=<dlna renderer name> \
--net=host \
--device /dev/snd:/dev/snd \
 --restart unless-stopped \
freesmall/dlna-render
```

环境变量：
- UPNP_DEVICE_NAME: 标记UPNP设备名

# GitlabDeploy
使用openresty和shell实现的服务端代码自动部署机制


## openresty/tengine 设置
```nginx
location /deploy {
    default_type text/html;
	  content_by_lua_file /path/to/deploy.lua;
}
```

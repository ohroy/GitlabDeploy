local cjson = require("cjson")
local key = "your key here"
local script = "/home/wwwroot/bash/gitlab.sh"
local log = "/tmp/gitlab.log"
--开始逻辑
local headers = ngx.req.get_headers()
local signature = headers["X-Gitlab-Token"]

if signature == nil then
    return ngx.exit(404)
end
if not signature==key then
    return ngx.exit(404)
end

ngx.req.read_body()
local body = ngx.req.get_body_data()
local data = cjson.decode(body)

if data.object_kind=="tag_push" then
    --local status, out, err = shell.execute(shell_cmd, {timeout = config.timeout})
     os.execute("bash " .. script .. " " .. data.project.git_ssh_url .. " " .. data.ref  .. " > " .. log .. " 2>&1")
end

ngx.say("ok")
ngx.exit(200)

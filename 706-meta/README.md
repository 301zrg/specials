# 706-meta

`706/` 的修改记录和规则环境版本表。只给 706 用，与仓库其他目录无关。
Change history and rule-environment versions for `706/` only.

| 文件 / File | 内容 / Contents |
| --- | --- |
| [CHANGELOG.md](CHANGELOG.md) | 每个规则环境改了什么、依据哪条旧裁定（附 wiki 历史版本或寒波亭出处）/ what changed per environment and which old ruling backs it |
| [versions.json](versions.json) | 机器读的环境表：环境 ID、生效时间（Unix 秒）、S 提交与 `706/` 子树、脚本树／卡数据／引擎的摘要。网页版按录像开局时间选环境，天梯助手按它切换覆盖脚本 / machine-readable environments used by the web replay player and the desktop assistant |

**为什么不放进 `706/`**：天梯助手遇到 `706/` 下任何非 `.lua` 文件都会停止更新，网页打包器和服务器上线脚本也按 `706/` 整目录取文件。
**Why not inside `706/`**: the desktop assistant refuses any non-`.lua` file there, and the web packager and server release script take `706/` as a whole.

规则 / Rules：

- 环境表只追加，不删除、不改写已有条目；放行过的区间（包括回滚）都要登记。
  Append only; every interval that went live, rollbacks included, gets an entry.
- 环境 ID 唯一，命名 `706-YYYYMMDD`（北京时间生效日），同日再有变化加 `-2`、`-3`；只有第一条的生效时间为 `null`，其余严格递增。
  Unique IDs `706-YYYYMMDD` (Beijing date), `-2`, `-3` for more changes on one day; only the first entry has a `null` start, the rest strictly increase.
- 版本标签 `706-YYYYMMDD` 打在脚本内容提交 S 上；本目录的更新是 S 的子提交 M。
  Tags point at the script commit S; this directory is updated in its child commit M.

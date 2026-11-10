# 706 修改记录 / 706 changelog

`706/` 是本服（OCG 2011 年 3 月环境）使用的旧裁定覆盖脚本。每个规则环境一节，最新的在最上面；机器读的版本表见 [versions.json](versions.json)。
`706/` holds this server's old-ruling override scripts (OCG March 2011 format). One section per rule environment, newest first; the machine-readable table is [versions.json](versions.json).

出处规则：旧裁定改动附 yugioh-wiki 的**历史版本**页（最早收录该裁定的版本，标注存档时间、age 和裁定日期），或寒波亭裁定原文。修 bug 的改动写“修 bug，无裁定依据”。
Sources: old-ruling changes link the yugioh-wiki **history version** that first carries the ruling (archive time, age and ruling date), or the Kanpatei ruling notes. Plain bug fixes say so.

## 706-20261110-3（生效 / effective: 2026-11-10 15:20:59 +08:00）

脚本内容提交 S / script commit: [`832fae822f73385b42019f08ee479d54e7d1a998`](https://github.com/301zrg/specials/commit/832fae822f73385b42019f08ee479d54e7d1a998) · `706/` 子树 / subtree: `f15857af133b9e7a57bd91e01448daf605d8f487` · 标签 / tag: `706-20261110-3`（打在 S 上 / on S）· 分界 / boundary: `1794295259`（Unix 秒 / seconds）
完整生效 Lua 树摘要 / effective Lua tree digest: 切换前 / before `3721e39e2d088e4cad54e4a09062b76eefe580465199f9b3ad74196ac6f60a95` → 切换后 / after `515670051227e9ae3bb4583eca57223114a93484f668dcd710461c0f561a12de`

只换一个文件，与 706-20261110-2 相同的方式：按维护者决定不等零房间，同目录原子替换，不重启、不开维护；分界取替换完成后的下一个整秒，替换前已开局的对局继续使用上一版。
One file, same procedure as 706-20261110-2: replaced without waiting for zero rooms (atomic same-directory replace, no restart, no maintenance); the boundary is the first whole second after the replace, and duels started earlier keep the previous version.

| 卡 / Card | 改动 / Change | 依据 / Source |
| --- | --- | --- |
| 26993374 X-剑士 乌尔德 / X-Saber Urz | 自首次上传（`a834afa`，2025-08-15）起 `706/c26993374.lua` 一直是真红眼暗钢龙的脚本，这张卡在游戏里按那张卡运作；换回乌尔德自己的脚本（与上游 `c26993374.lua` 一致）。服务器基础目录的 `script/c26993374.lua` 同样是错的，所以保留覆盖而不是删除 / since the first upload the file held the Red-Eyes Darkness Metal Dragon script; it now has the Urz script (identical to upstream). The server base `script/c26993374.lua` is wrong too, so the override stays | 修 bug（上传时放错文件），无裁定依据 / bug fix (wrong file uploaded), no ruling |

## 706-20261110-2（生效 / effective: 2026-11-10 10:13:34 +08:00）

脚本内容提交 S / script commit: [`323d915d715240565e3f4d4ad3a8cb6e56355f82`](https://github.com/301zrg/specials/commit/323d915d715240565e3f4d4ad3a8cb6e56355f82) · `706/` 子树 / subtree: `7529253d18814b4217a58c2f2e985a394f0c6d00` · 标签 / tag: `706-20261110-2`（打在 S 上 / on S）· 分界 / boundary: `1794276814`（Unix 秒 / seconds）
完整生效 Lua 树摘要 / effective Lua tree digest: 切换前 / before `905a9e2a4322423f2caa25f4040d2d11d818b6ca35881d02085dcf8acca144ac` → 切换后 / after `3721e39e2d088e4cad54e4a09062b76eefe580465199f9b3ad74196ac6f60a95`

紧急修复，只换一个文件。玩家报告后按维护者决定**不等零房间**直接替换（同目录原子替换，不重启、不开维护）；分界取替换完成后的下一个整秒，替换前已开局的对局继续使用上一版。
Hot fix of one file. After a player report the maintainer chose to replace it **without waiting for zero rooms** (atomic same-directory replace, no restart, no maintenance); the boundary is the first whole second after the replace, and duels started earlier keep the previous version.

| 卡 / Card | 改动 / Change | 依据 / Source |
| --- | --- | --- |
| 32603633 究极·背水之阵 / Backs to the Wall | 706-20261110 要求特召数等于空位数，墓地不同名「六武众」少于空位时效果因脚本错误失败；改为特召“空位数”与“可选的不同卡名数”中较小者 / 706-20261110 required exactly as many as free zones and failed with a script error when fewer different-name "Six Samurai" were in the GY; now summons the smaller of the free zones and the eligible names | 修 bug，裁定不变 / bug fix, ruling unchanged：[wiki 2011-08-08 版（age=48）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%B5%E6%B6%CB%A1%A6%C7%D8%BF%E5%A4%CE%BF%D8%A1%D5&age=48)「自分フィールド上に可能な限り特殊召喚する（同名カードは１枚まで）」 |

## 706-20261110（生效 / effective: 2026-11-10 03:35:02 +08:00）

脚本内容提交 S / script commit: [`19ace09c7fc7c80ceb03eef99621942a7b135bc4`](https://github.com/301zrg/specials/commit/19ace09c7fc7c80ceb03eef99621942a7b135bc4) · `706/` 子树 / subtree: `4ef49453974f60fd5b91cb54bc7bc6713541c834` · 标签 / tag: `706-20261110`（打在 S 上 / on S）· 分界 / boundary: `1794252902`（Unix 秒 / seconds）
完整生效 Lua 树摘要 / effective Lua tree digest: 切换前 / before `cfaa3d5932f2fd42492bb4baa539dafa35e50960534d87009ac336a5f9d587d8` → 切换后 / after `905a9e2a4322423f2caa25f4040d2d11d818b6ca35881d02085dcf8acca144ac`

元数据勘误（2026-11-10）/ metadata erratum: [versions.json](versions.json) 本条的 `bootstrapSha256`（合成后 `utility.lua` 的 SHA）最初误抄了上一条的值，已更正为 `59a4dbd4a2377bce6ca830d4da0b6b2665e01c87206274028d627833b508e45e`。规则内容、`706/` 子树和分界都不变，不是新环境。/ This entry first copied the previous `bootstrapSha256` (the SHA of the composed `utility.lua`); corrected. Rules, the `706/` subtree and the boundary are unchanged; this is not a new environment.

### 706 覆盖 / overrides

| 卡 / Card | 改动 / Change | 依据 / Source |
| --- | --- | --- |
| 32603633 究极·背水之阵 / Backs to the Wall | 必须尽可能多地特殊召唤 / must Special Summon as many as possible | 卡文原文 / card text: [wiki 2011-08-08 版（age=48）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%B5%E6%B6%CB%A1%A6%C7%D8%BF%E5%A4%CE%BF%D8%A1%D5&age=48)：「自分フィールド上に可能な限り特殊召喚する（同名カードは１枚まで）」 |
| 96782886 精神脑魔 / Mind Master | 收录服务器一直在用的旧版（勘误前：不限每回合一次，不能解放自身）/ add the pre-errata script the server has been running (no once-per-turn, cannot release itself) | 卡文原文 / card text: [wiki 2011-08-19 版（age=71）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%A5%E1%A5%F3%A5%BF%A5%EB%A5%DE%A5%B9%A5%BF%A1%BC%A1%D5&age=71)：「自分フィールド上の「メンタルマスター」以外のサイキック族モンスター１体を…」。上游 [`531580ce4`](https://github.com/mycard/ygopro-scripts/commit/531580ce4)（2026-06-23）按 26/07/01 的勘误修改 / upstream follows the 26/07/01 errata |
| `special.lua`（11012887 朱罗纪瓜巴龙 / Jurrac Guaiba 等） | “战斗破坏对方怪兽时”的效果，在双方一起被除外后（如攻击异次元的女战士）也能发动 / “destroys a monster by battle” effects still activate when both monsters are banished together (e.g. vs D.D. Warrior Lady) | [wiki 瓜巴龙 2011-07-13 版（age=23）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%A5%B8%A5%E5%A5%E9%A5%C3%A5%AF%A1%A6%A5%B0%A5%A2%A5%A4%A5%D0%A1%D5&age=23)：「ダメージステップの最後に、戦闘によって破壊されたモンスターが墓地へ送られた又は除外されたタイミングにて発動します」(11/07/12) |
| 43711255 禁止令 / Prohibition、77565204 未来融合 / Future Fusion、`special.lua` | 完整还原 2011 年旧裁定（被宣言的卡的各项限制、与未来融合的配合；二重怪兽与墓地改名不作例外）/ full 2011 ruling (restrictions on the declared card, interaction with Future Fusion; Gemini monsters and graveyard name changes get no exception) | [wiki 禁止令 2011-11-16 版（age=1）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%B6%D8%BB%DF%CE%E1%A1%D5&age=1)（最早的存档 / earliest archive）、[2012-03-08 版（age=6）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%B6%D8%BB%DF%CE%E1%A1%D5&age=6)、[2012-04-11 版（age=12）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%B6%D8%BB%DF%CE%E1%A1%D5&age=12)：未来融合相关 (12/03/08, 12/04/04, 12/04/10) 为截止日后裁定（按例外规则采用）/ post-cutoff rulings, used under the exception rule；[冥界的魔王 哈·迪斯 2011-08-12 版（age=41）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%CC%BD%B3%A6%A4%CE%CB%E2%B2%A6%20%A5%CF%A1%A6%A5%C7%A5%B9%A1%D5&age=41)、[「デュアル」词条 2010-05-15 版（age=1）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A5%C7%A5%E5%A5%A2%A5%EB&age=1)；[寒波亭](https://note.com/sabae5280/n/n95ba4b085cf6)。逐条对照见附件《禁止令旧裁定说明》/ itemised in the attached Prohibition notes |
| 102380 熔岩魔神 / Lava Golem、63014935 火山女王 / Volcanic Queen、75732622 拷问巨人 / Grinder Golem、95291684 异次元的独角战士 / D.D. Unicorn Knight、95637655 后援战士 / Backup Warrior、23516703 召唤限制器 / Summon Limit、4168871 黑羽之宝札 / Cards for Black Feathers、54977057 天空的宝札 / Cards from the Sky、98645731 强欲而谦虚之壶 / Pot of Duality、`special.lua` | 召唤／特殊召唤被无效时的次数计算按旧裁定 / summon counting when a summon is negated follows the old rulings | [强欲而谦虚之壶 2011-08-25 版（age=1）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%B6%AF%CD%DF%A4%C7%B8%AC%B5%F5%A4%CA%D4%E4%A1%D5&age=1)、[真红眼飞龙 2009-02-12 版（age=36）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%BF%BF%B9%C8%B4%E3%A4%CE%C8%F4%CE%B5%A1%D5&age=36)、[「通常召喚」2011-01-31 版（age=21）](https://yugioh-wiki.net/index.php?cmd=backup&page=%C4%CC%BE%EF%BE%A4%B4%AD&age=21)、[火山女王（age=34）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%A5%F4%A5%A9%A5%EB%A5%AB%A5%CB%A5%C3%A5%AF%A1%A6%A5%AF%A5%A4%A1%BC%A5%F3%A1%D5&age=34)、[拷问巨人（age=1）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%A5%C8%A1%BC%A5%C1%A1%A6%A5%B4%A1%BC%A5%EC%A5%E0%A1%D5&age=1)、[异次元的独角战士（age=18）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%B0%DB%BC%A1%B8%B5%A4%CE%B0%EC%B3%D1%C0%EF%BB%CE%A1%D5&age=18)、[后援战士（age=10）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%A5%D0%A5%C3%A5%AF%A5%A2%A5%C3%A5%D7%A1%A6%A5%A6%A5%A9%A5%EA%A5%A2%A1%BC%A1%D5&age=10)、[召唤限制器 2008-08-21 版（age=16）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%A5%B5%A5%E2%A5%F3%A5%EA%A5%DF%A5%C3%A5%BF%A1%BC%A1%D5&age=16)、[寒波亭·强欲而谦虚之壶](https://note.com/sabae5280/n/n95ba4b085cf6#089997D8-7C1E-4235-BFD5-6FF5FE4844F2)。逐条对照见附件《召唤无效计次说明》/ itemised in the attached summon-counting notes |
| 5861892 秘仪之力EX-光之支配者 / Arcana Force EX - The Light Ruler | 保留勘误前的旧版：先无效再降攻，天邪鬼的诅咒（77622396）适用中仍会无效 / keep the pre-errata script: negate first, then lose ATK; still negates while Reverse Trap (77622396) applies | [wiki 2011-07-05 版（age=64）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%A5%A2%A5%EB%A5%AB%A5%CA%A5%D5%A5%A9%A1%BC%A5%B9%A3%C5%A3%D8%A1%DD%A3%D4%A3%C8%A3%C5%20%A3%CC%A3%C9%A3%C7%A3%C8%A3%D4%20%A3%D2%A3%D5%A3%CC%A3%C5%A3%D2%A1%D5&age=64)：《あまのじゃくの呪い》适用中，无效效果照常发动、攻击力上升 1000 (11/07/04)。上游 [`0b0e22637`](https://github.com/mycard/ygopro-scripts/commit/0b0e22637)（2026-08-07）为勘误 / upstream errata |
| 52860176 凭依的血魂 / Possessed Dark Soul | 保留旧版：空怪兽区不够也能发动，放不下的被破坏 / keep the old script: can activate without enough free zones; the rest are destroyed | [wiki 2010-07-23 版（age=37）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%D8%E1%B0%CD%A4%B9%A4%EB%A5%D6%A5%E9%A5%C3%A5%C9%A1%A6%A5%BD%A5%A6%A5%EB%A1%D5&age=37)：「２体のコントロールを得て、残りの１体は破壊されます」(10/07/21)。上游 [`f55d0460a`](https://github.com/mycard/ygopro-scripts/commit/f55d0460a)（2026-08-07）改为空格不够不能发动 / upstream now requires enough zones |
| 37812118 圣杯A / Cup of Ace | 保留旧版：双方卡组都有 2 张以上才能发动 / keep the old script: both decks must hold 2+ cards | [wiki 2011-02-25 版（age=45）](https://yugioh-wiki.net/index.php?cmd=backup&page=%A1%D4%A5%AB%A5%C3%A5%D7%A1%A6%A5%AA%A5%D6%A1%A6%A5%A8%A1%BC%A5%B9%A1%D5&age=45)：「お互いのデッキの枚数が２枚以上でないと発動できません」(11/02/24)；现行页面已删去这条 / removed from the current page。上游 [`a29168c74`](https://github.com/mycard/ygopro-scripts/commit/a29168c7496466bb641502ebe4d7bcce17a7b5c1)（2026-08-25）改为任意一方能抽即可 / upstream now needs only one player |
| 10032958 神龙-艾克塞利翁 / Divine Dragon - Excelion | 删除覆盖，恢复上游原版 / drop the override; the upstream script applies again | 撤回此前的错误修改，不涉及旧裁定 / reverts an earlier mistaken change; no ruling involved |
| `special.lua` | 删除防重复载入代码（各环境 `PreloadUds()` 都只执行一次）/ remove the re-load guard (`PreloadUds()` runs once in every environment) | 修整，无裁定依据 / cleanup, no ruling |

### 服务器基础目录同步上游 / base `script/` synced with upstream

22 张卡换成上游 `mycard/ygopro-scripts@5864b6f` 的版本，均为修 bug，无裁定依据 / 22 cards take the upstream `5864b6f` scripts; all bug fixes, no ruling involved：
双重祭品修复 / double-tribute fix（`f4a2acd41`）11662742、15090429、17444133、23087070、38479725、41089128、44436472、53461122、54766667、99865167、81755371、564541、62729173、92084010、97574404；从墓地特招的检查 / graveyard Special Summon check（`c38a7a9b3`）45133463、53855409；其他 / others 87557188、71466592、78053598、75043725、92854392。

## 706-20260907（兼容候选，无严格分界 / compatibility candidate, no exact boundary）

脚本内容提交 / script commit: [`d6008e9`](https://github.com/301zrg/specials/commit/d6008e9832e5666e665a84dca2e8e59810b3cdfa) · `706/` 子树 / subtree: `fe58410ca5a60f879e8c92e94c3fba86539e9006` · 完整生效 Lua 树摘要 / digest: `cfaa3d5932f2fd42492bb4baa539dafa35e50960534d87009ac336a5f9d587d8`

这是 A 线上线前取得的服务器快照，用于更早的录像。2026-09-01～09-07 有多次 706 提交，部署时间没有记录，所以不是严格的历史分界。
Server snapshot taken before the batch above, used for older replays. Several 706 commits landed 2026-09-01..07 without recorded deploy times, so this is not an exact historical boundary.

当时服务器基础目录与上游 `5864b6f` 在 1103 卡池内有 26 张不同：96782886（上游 06-23 勘误前的版本）、上面列出的 22 张、5861892、52860176、37812118。
At that time the server's base `script/` differed from upstream `5864b6f` on 26 cards in the 1103 pool: 96782886 (pre-06-23-errata), the 22 cards above, and 5861892, 52860176, 37812118.

## 历史 / History

2025-08-15 `a834afa` 至 `d6008e9` 共 56 次涉及 `706/` 的提交，待补写（每条附提交链接和出处）。
The 56 commits touching `706/` from `a834afa` (2025-08-15) to `d6008e9` are still to be written up, each with its commit link and sources.

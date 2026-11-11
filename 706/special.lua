-- 解决光道武僧踢反转怪的问题跟反转召唤被神警不算场上送墓的问题
Auxiliary.__flip_effect_list = Auxiliary.__flip_effect_list or {}

function Auxiliary.PreloadUds()

    local flip_effect_list = Auxiliary.__flip_effect_list
    local base = {}
	
	base.IsForbidden = Card.IsForbidden
	base.GetActivityCount = Duel.GetActivityCount
	base.AddCustomActivityCounter = Duel.AddCustomActivityCounter
	base.GetCustomActivityCount = Duel.GetCustomActivityCount
	--不含"召唤被无效"记录的原始计数（召唤限制器等例外用）
	Auxiliary.GetActivityCountRaw = base.GetActivityCount
	base.IsPreviousLocation = Card.IsPreviousLocation
	base.GetPreviousLocation = Card.GetPreviousLocation
	base.IsFaceup = Card.IsFaceup
	base.GetPosition = Card.GetPosition
	base.NegateSummon = Duel.NegateSummon
	base.RegisterEffect = Card.RegisterEffect

	base.redirect_effects = {
		[EFFECT_LEAVE_FIELD_REDIRECT] = true,
		[EFFECT_TO_HAND_REDIRECT] = true,
		[EFFECT_TO_DECK_REDIRECT] = true,
		[EFFECT_TO_GRAVE_REDIRECT] = true,
		[EFFECT_REMOVE_REDIRECT] = true,
	}

	--hook下面这四个方法使涉及反转召唤被召唤无效的卡的位置按旧裁定显示
	Card.IsPreviousLocation = function(c,location)
		local re = c:GetReasonEffect()
		if base.IsPreviousLocation(c,LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and c:IsReason(REASON_EFFECT) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
			return false
		end
		return base.IsPreviousLocation(c,location)
	end
	Card.GetPreviousLocation = function(c)
		local re = c:GetReasonEffect()
		if base.IsPreviousLocation(c,LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and c:IsReason(REASON_EFFECT) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
			return 0
		end
		return base.GetPreviousLocation(c)
	end
	Card.IsFaceup = function(c)
		local re = Duel.GetChainInfo(1, CHAININFO_TRIGGERING_EFFECT)
		if c:IsLocation(LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
			return false
		end
		return base.IsFaceup(c)
	end
	Card.GetPosition = function(c)
		local re = Duel.GetChainInfo(1, CHAININFO_TRIGGERING_EFFECT)
		if c:IsLocation(LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
			return POS_FACEDOWN
		end
		return base.GetPosition(c)
	end

	--book NegateSummon给反转召唤被无效的怪兽取消完成苏生限制使其不能被苏生
	Duel.NegateSummon = function(eg)
		if eg.GetCount==nil or eg:GetCount() == 1 then
			local re = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT)
			if re.GetCode(re) == EVENT_FLIP_SUMMON then 
				eg:GetFirst():SetStatus(STATUS_PROC_COMPLETE, false)
			end
		end
		return base.NegateSummon(eg)
	end

	--hook RegisterEffect 以将注册的反转效果全部放进自行维护的数组中并且将离场不去原区域的效果全部加上反转召唤被神警则不触发的条件
    Card.RegisterEffect = function(c, e, forced)
		--召唤被无效计次的全局监听，第一次有卡注册效果时登记一次
		Auxiliary.NegActRegister()
		if e and e.GetCode then
			local e_code = e:GetCode()
			if e_code == EVENT_FLIP then
				local cid = c:GetCode()
				flip_effect_list[cid] = flip_effect_list[cid] or {}
				table.insert(flip_effect_list[cid], e)
			elseif base.redirect_effects[e_code] then
				local cid = c:GetCode()
				--非大宇宙类对全场起作用的效果才执行以避免bug
				if not e:IsHasProperty(EFFECT_FLAG_IGNORE_RANGE) then
					local old_condition = e:GetCondition()
					e:SetCondition(function(e2,tp2,eg2,ep2,ev2,re2,r2,rp2)
						local re = Duel.GetChainInfo(1, CHAININFO_TRIGGERING_EFFECT)
						if c:IsLocation(LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_FLIP) and re~=nil and re:GetCode() == EVENT_FLIP_SUMMON and re:GetCategory()&CATEGORY_DISABLE_SUMMON ~= 0 then
							return false
						end
                        return old_condition == nil or old_condition(e2,tp2,eg2,ep2,ev2,re2,r2,rp2)
					end)
				end
			elseif (e_code == EFFECT_CHANGE_CODE or e_code == EFFECT_ADD_CODE) and e:IsHasType(EFFECT_TYPE_SINGLE) then
				--禁止令旧裁定：禁止令适用后出现的卡不能变成被宣言的卡名（08/09/29、08/12/11）
				local old_condition = e:GetCondition()
				e:SetCondition(function(e2,tp2,eg2,ep2,ev2,re2,r2,rp2)
					if Auxiliary.KinshiNameBlocked(e2) then return false end
					return old_condition == nil or old_condition(e2,tp2,eg2,ep2,ev2,re2,r2,rp2)
				end)
			end
		end
        return base.RegisterEffect(c, e, forced)
    end

	--禁止令旧裁定：被禁止令禁止化的卡也视为 IsForbidden（影响未来融合选择、宝玉兽放置等）
	Card.IsForbidden = function(c)
		return base.IsForbidden(c) or Auxiliary.KinshiForbidden(c)
	end

	--旧裁定：被无效的召唤也算"本回合进行过召唤"（说明见 ygopro_old/召唤无效计次旧裁定整理.md）
	Duel.GetActivityCount = function(p,...)
		local res = {base.GetActivityCount(p,...)}
		local types = {...}
		for i=1,#types do
			if res[i] then res[i] = res[i] + Auxiliary.NegActExtra(p,types[i]) end
		end
		return table.unpack(res)
	end
	Duel.AddCustomActivityCounter = function(id,atype,f)
		Auxiliary.__custom_act_filter = Auxiliary.__custom_act_filter or {}
		Auxiliary.__custom_act_filter[id] = Auxiliary.__custom_act_filter[id] or {}
		--Core用emplace保留同一ID／类型首次注册的过滤器。
		if not Auxiliary.__custom_act_filter[id][atype] then
			Auxiliary.__custom_act_filter[id][atype] = f
		end
		return base.AddCustomActivityCounter(id,atype,f)
	end
	Duel.GetCustomActivityCount = function(id,p,atype)
		return base.GetCustomActivityCount(id,p,atype) + Auxiliary.NegActCustomExtra(id,p,atype)
	end

	-- provide Card.GetFlipEffect to retrieve the registered flip effect of a card
    Card.GetFlipEffect = function(c)
        local cid = c:GetCode()
        local list = flip_effect_list[cid]
        if not list then return nil end
        for _, e in ipairs(list) do
            if e:GetHandler() == c then
                return e
            end
        end
        return nil
    end

end	

--condition of EVENT_DAMAGE_STEP_END + this monster is releate to battle + opponent monster destroyed by battle
function Auxiliary.dserodcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc==nil then return false end
	if bc:IsReason(REASON_BATTLE) then return true end
	--旧裁定：战斗破坏确定后在伤害步骤结束前被异次元的女战士/异次元的战士等效果移走（非破坏），仍视为战斗破坏了对方怪兽
	return bc:IsStatus(STATUS_BATTLE_DESTROYED) and not bc:IsReason(REASON_DESTROY)
end

--禁止令(43711255)旧裁定公共方法，说明见 ygopro_old/禁止令旧裁定整理.md
--每次禁止令处理时登记 {card=禁止令, code=宣言卡号, fid=其效果的FieldID}
Auxiliary.__kinshi_list = Auxiliary.__kinshi_list or {}
function Auxiliary.KinshiHasLabel(c,code,label)
	for _,l in ipairs({c:GetFlagEffectLabel(code)}) do
		if l==label then return true end
	end
	return false
end
function Auxiliary.KinshiRegister(kc,code,fid)
	kc:RegisterFlagEffect(43711255,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	table.insert(Auxiliary.__kinshi_list,{card=kc,code=code,fid=fid})
end
--该次禁止令是否仍在场上生效
function Auxiliary.KinshiAlive(en)
	local kc=en.card
	return kc:IsLocation(LOCATION_SZONE) and kc:IsFaceup() and not kc:IsDisabled()
		and Auxiliary.KinshiHasLabel(kc,43711255,en.fid)
end
--c 相对于某次禁止令的状态：0=不受影响 1=禁止化 2=禁止令处理时在场、之后回到手卡或卡组（仅离场时的诱发可发动）
function Auxiliary.KinshiStatus(en,c)
	if not c:IsOriginalCodeRule(en.code) then return 0 end
	if c:IsOnField() then
		return c:GetRealFieldID()>en.fid and 1 or 0
	end
	--禁止令处理时已在场的卡：直接送去墓地后不受影响（10/10/23、08/06/19、08/06/20），回手卡或卡组时的诱发有效（13/04/12）
	if Auxiliary.KinshiHasLabel(c,43711255,en.fid) and c:IsPreviousLocation(LOCATION_ONFIELD) then
		if c:IsLocation(LOCATION_GRAVE) then return 0 end
		if c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA) then return 2 end
	end
	return 1
end
--由禁止令卡本身查它当前这次生效对 c 的状态
function Auxiliary.KinshiStatusByHandler(kc,c)
	local list=Auxiliary.__kinshi_list
	for i=#list,1,-1 do
		local en=list[i]
		if en.card==kc and Auxiliary.KinshiAlive(en) then
			return Auxiliary.KinshiStatus(en,c)
		end
	end
	return 0
end
--c 是否被任一生效中的禁止令禁止化
function Auxiliary.KinshiForbidden(c)
	for _,en in ipairs(Auxiliary.__kinshi_list) do
		if Auxiliary.KinshiAlive(en) and Auxiliary.KinshiStatus(en,c)>=1 then return true end
	end
	return false
end
--改卡名效果 e 是否因禁止令而不适用：要变成的卡名正被宣言，且该卡不是禁止令处理前就在场
function Auxiliary.KinshiNameBlocked(e)
	local list=Auxiliary.__kinshi_list
	if #list==0 then return false end
	local c=e:GetHandler()
	local v=e:GetValue()
	if type(v)=="function" then v=v(e,c) end
	if type(v)~="number" then return false end
	for _,en in ipairs(list) do
		if en.code==v and Auxiliary.KinshiAlive(en) and not (c:IsOnField() and c:GetRealFieldID()<en.fid) then
			return true
		end
	end
	return false
end
--离场时的诱发效果对应的事件
function Auxiliary.KinshiLeaveEvent(code)
	return code==EVENT_LEAVE_FIELD or code==EVENT_TO_HAND or code==EVENT_TO_DECK
end

--召唤被无效计次（旧裁定），说明见 ygopro_old/召唤无效计次旧裁定整理.md
--每个玩家本回合：sum=被无效的通常召唤 flip=被无效的反转召唤 sp=被无效的召唤规则特招+发动成功但没特招出来的效果
--custom[计数器ID][活动类型]=事件发生时已判定的次数，不保留可变Card对象
function Auxiliary.NegActState(p)
	local s=Auxiliary.__neg_act
	local turn=Duel.GetTurnCount()
	if not s or s.turn~=turn then
		s={turn=turn}
		for i=0,1 do
			s[i]={sum=0,flip=0,sp=0,custom={}}
		end
		Auxiliary.__neg_act=s
	end
	return s[p]
end
function Auxiliary.NegActExtra(p,atype)
	if p~=0 and p~=1 then return 0 end
	local st=Auxiliary.NegActState(p)
	if atype==ACTIVITY_SUMMON or atype==ACTIVITY_NORMALSUMMON then return st.sum end
	if atype==ACTIVITY_FLIPSUMMON then return st.flip end
	if atype==ACTIVITY_SPSUMMON then return st.sp end
	return 0
end
--自定义计数器：查询只读已固定的历史结果，不再次运行过滤器
function Auxiliary.NegActCustomExtra(id,p,atype)
	if p~=0 and p~=1 then return 0 end
	local counts=Auxiliary.NegActState(p).custom[id]
	return counts and counts[atype] or 0
end
function Auxiliary.NegActAddCards(st,atype,eg)
	--与Core一样，在活动发生时对已注册的过滤器判定；后注册不追溯。
	for id,filters in pairs(Auxiliary.__custom_act_filter or {}) do
		local f=filters[atype]
		if f then
			for tc in aux.Next(eg) do
				if not f(tc) then
					st.custom[id]=st.custom[id] or {}
					st.custom[id][atype]=(st.custom[id][atype] or 0)+1
				end
			end
		end
	end
end
function Auxiliary.NegActRegister()
	if Auxiliary.__neg_act_registered then return end
	Auxiliary.__neg_act_registered=true
	Auxiliary.__neg_act_pending={}
	local function reg(code,op)
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(code)
		ge:SetOperation(op)
		Duel.RegisterEffect(ge,0)
	end
	--通常召唤被无效：算进行过召唤、通常召唤（真红眼飞龙 09/02/11）
	reg(EVENT_SUMMON_NEGATED,function(e,tp,eg,ep,ev,re,r,rp)
		local st=Auxiliary.NegActState(ep)
		st.sum=st.sum+1
		Auxiliary.NegActAddCards(st,ACTIVITY_SUMMON,eg)
		Auxiliary.NegActAddCards(st,ACTIVITY_NORMALSUMMON,eg)
	end)
	reg(EVENT_FLIP_SUMMON_NEGATED,function(e,tp,eg,ep,ev,re,r,rp)
		local st=Auxiliary.NegActState(ep)
		st.flip=st.flip+1
		Auxiliary.NegActAddCards(st,ACTIVITY_FLIPSUMMON,eg)
	end)
	--召唤规则的特殊召唤被无效：算进行过特殊召唤（壶 11/02/09、后援战士 10/01/06）
	reg(EVENT_SPSUMMON_NEGATED,function(e,tp,eg,ep,ev,re,r,rp)
		local st=Auxiliary.NegActState(ep)
		st.sp=st.sp+1
		Auxiliary.NegActAddCards(st,ACTIVITY_SPSUMMON,eg)
	end)
	--带特殊召唤的效果：发动被无效不算（壶 11/02/09、11/02/11）；发动成功但没特招出来（效果被无效、处理失败）算（壶 11/02/09、11/01/16）
	reg(EVENT_CHAINING,function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON) then
			Auxiliary.__neg_act_pending[ev]={p=rp,before=Auxiliary.GetActivityCountRaw(rp,ACTIVITY_SPSUMMON)}
		else
			Auxiliary.__neg_act_pending[ev]=nil
		end
	end)
	reg(EVENT_CHAIN_NEGATED,function(e,tp,eg,ep,ev,re,r,rp)
		Auxiliary.__neg_act_pending[ev]=nil
	end)
	reg(EVENT_CHAIN_SOLVED,function(e,tp,eg,ep,ev,re,r,rp)
		local pd=Auxiliary.__neg_act_pending[ev]
		if not pd then return end
		Auxiliary.__neg_act_pending[ev]=nil
		--真的特招成功了，核心本身已计数，不重复计
		if Auxiliary.GetActivityCountRaw(pd.p,ACTIVITY_SPSUMMON)<=pd.before then
			local st=Auxiliary.NegActState(pd.p)
			st.sp=st.sp+1
		end
	end)
end

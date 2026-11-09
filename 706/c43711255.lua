--禁止令
--旧裁定还原：不用底层的 EFFECT_FORBIDDEN，改为脚本层分开实现各项限制（底层的禁止令会挡掉"其他卡效果特招"等，属新裁定）
--判定统一走 utility.lua / special.lua 的 aux.KinshiStatus 等方法，说明见 ygopro_old/禁止令旧裁定整理.md
function c43711255.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c43711255.target)
	e1:SetOperation(c43711255.activate)
	c:RegisterEffect(e1)
end
function c43711255.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
--禁止化（状态 1 或 2）
function c43711255.bantg(e,c)
	return aux.KinshiStatusByHandler(e:GetHandler(),c)>=1
end
--效果不适用：只对状态 1 的卡
--二重怪兽的"视为通常怪兽"、"在场上·墓地视为某卡名"之类也属于效果，一并不适用
--（旧裁定：被冥界的魔王 哈·迪斯战斗破坏的二重怪兽在墓地视为效果怪兽 08/01/14；技能抽取下二重怪兽视为效果怪兽、不能再度召唤；
--  哈·迪斯页 2011/08/12 版：非常时型的同名卡扱い会被无效）
function c43711255.distg(e,c)
	return aux.KinshiStatusByHandler(e:GetHandler(),c)==1
end
--不能通常召唤（被宣言的二重怪兽已视为效果怪兽，本来就不能再度召唤）
function c43711255.sumtg(e,c)
	return c43711255.bantg(e,c)
end
--不能发动：状态 2 的卡只放过离场时的诱发效果（13/04/12 ライティー、ナーガ），之后在手卡发动不行（13/04/12 サンダー・ドラゴン）
function c43711255.actval(e,re,tp)
	local st=aux.KinshiStatusByHandler(e:GetHandler(),re:GetHandler())
	if st==0 then return false end
	if st==2 and re:IsHasType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F) and aux.KinshiLeaveEvent(re:GetCode()) then return false end
	return true
end
--不能特殊召唤
function c43711255.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if not c43711255.bantg(e,c) then return false end
	--融合召唤、仪式召唤即使由其他卡进行也不行（12/03/08、12/04/04）
	if sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION or sumtype&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL then
		--例外：禁止令处理前已发动并选定怪兽的未来融合，照常特招（12/03/08、12/04/10）
		local sc=se and se:GetHandler()
		if sc and sc:IsCode(77565204) then
			for _,en in ipairs(aux.__kinshi_list) do
				if en.card==e:GetHandler() and aux.KinshiAlive(en) and aux.KinshiHasLabel(sc,43711255,en.fid) then return false end
			end
		end
		return true
	end
	--召唤规则、自身效果特招不行；其他卡的效果特招可以（之后受禁止化限制）
	if se==nil then return true end
	local sh=se:GetHandler()
	if sh and sh==c then return true end
	return false
end
function c43711255.fffilter(c)
	return c:IsFaceup() and c:IsCode(77565204) and c:GetFlagEffect(77565204)>0
end
function c43711255.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	c:SetHint(CHINT_CARD,ac)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0xff,0xff)
	e2:SetTarget(c43711255.bantg)
	e2:SetLabel(ac)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--登记这次生效，并以 e2 的 FieldID 区分"处理前已在场"的卡
	local fid=e2:GetFieldID()
	aux.KinshiRegister(c,ac,fid)
	--处理时在场的被宣言卡：打标记，直接送去墓地或回手卡、卡组后据此判断
	local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,ac)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(43711255,RESET_EVENT+RESET_TOFIELD+RESET_TEMP_REMOVE+RESET_REMOVE+RESET_OVERLAY,0,1,fid)
	end
	--处理时已发动并选定怪兽的未来融合：打标记，之后照常特招
	local fg=Duel.GetMatchingGroup(c43711255.fffilter,0,LOCATION_SZONE,LOCATION_SZONE,nil)
	for tc in aux.Next(fg) do
		tc:RegisterFlagEffect(43711255,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c43711255.actval)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_DISABLE)
	e5:SetTarget(c43711255.distg)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetValue(aux.TRUE)
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetValue(aux.TRUE)
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e2:Clone()
	e8:SetValue(aux.TRUE)
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e2:Clone()
	e9:SetValue(aux.TRUE)
	e9:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e9)
	local e10=e2:Clone()
	e10:SetCode(EFFECT_CANNOT_SUMMON)
	e10:SetTarget(c43711255.sumtg)
	c:RegisterEffect(e10)
	local e11=e2:Clone()
	e11:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e11)
	local e12=e2:Clone()
	e12:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e12)
	local e13=e2:Clone()
	e13:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e13)
	local e14=e2:Clone()
	e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(1,1)
	e14:SetTarget(c43711255.splimit)
	c:RegisterEffect(e14)
	Duel.AdjustInstantly(c)
end

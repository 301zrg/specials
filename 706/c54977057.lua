-- 天空の宝札
---@param c Card
function c54977057.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW + CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c54977057.cost)
    e1:SetTarget(c54977057.target)
    e1:SetOperation(c54977057.activate)
    c:RegisterEffect(e1)
end
function c54977057.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    --旧裁定的"被无效的特殊召唤也算进行过特殊召唤"由 utility.lua / special.lua 统一 hook 的 GetActivityCount 处理
    if chk == 0 then
        return Duel.GetActivityCount(tp, ACTIVITY_SPSUMMON) == 0 and Duel.GetActivityCount(tp, ACTIVITY_BATTLE_PHASE) == 0
    end
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE + PHASE_END)
    e1:SetTargetRange(1, 0)
    Duel.RegisterEffect(e1, tp)
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BP)
    Duel.RegisterEffect(e2, tp)
end
function c54977057.filter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:IsAbleToRemove()
end
function c54977057.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsPlayerCanDraw(tp, 2) and
                   Duel.IsExistingMatchingCard(c54977057.filter, tp, LOCATION_HAND, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_HAND)
end
function c54977057.activate(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, c54977057.filter, tp, LOCATION_HAND, 0, 1, 1, nil)
    if Duel.Remove(g, POS_FACEUP, REASON_EFFECT)>0 then
        Duel.Draw(tp, 2, REASON_EFFECT)
    else
        Duel.ConfirmCards(1-tp, Duel.GetFieldGroup(tp, LOCATION_HAND, 0))
        Duel.ShuffleHand(tp)
    end

end

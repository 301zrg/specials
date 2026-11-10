-- 六武衆の荒行
---@param c Card
function c27821104.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c27821104.target)
    e1:SetOperation(c27821104.activate)
    c:RegisterEffect(e1)
end
function c27821104.tfilter(c, atk, code, e, tp)
    return c:IsSetCard(0x103d) and not c:IsCode(code) and c:IsAttack(atk) and
               c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function c27821104.filter(c, e, tp)
    return c:IsFaceup() and c:IsSetCard(0x103d) and
               Duel.IsExistingMatchingCard(c27821104.tfilter, tp, LOCATION_DECK, 0, 1, nil, c:GetAttack(), c:GetCode(),
            e, tp)
end
function c27821104.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c27821104.filter(chkc, e, tp)
    end
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
                   Duel.IsExistingTarget(c27821104.filter, tp, LOCATION_MZONE, 0, 1, nil, e, tp)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
    local g = Duel.SelectTarget(tp, c27821104.filter, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end
-- Main-deck "Six Samurai" monsters of the 1103 pool by ATK (Extra Deck monsters such as
-- Legendary Six Samurai - Shi En cannot be summoned from the Deck). If no card with a
-- different name has this ATK, it is evident that nothing fits and the deck is not shown
-- (Mind Crush: confirmable except when absence is evident).
c27821104.deck_atk = {
    [200] = {2511717, 44430454},
    [400] = {1498130, 61737116},
    [500] = {65685470},
    [1000] = {69025477},
    [1300] = {64398890},
    [1400] = {31904181},
    [1500] = {48505422, 90397998},
    [1600] = {74094021, 78792195},
    [1700] = {27782503, 75116619},
    [1800] = {49721904, 95519486},
    [2100] = {83039729},
}
function c27821104.could_be_in_deck(atk, code)
    for _, id in ipairs(c27821104.deck_atk[atk] or {}) do
        if id ~= code then
            return true
        end
    end
    return false
end
function c27821104.activate(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then
        return
    end
    local tc = Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsFacedown() then
        return
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local atk = tc:GetAttack()
    local sg = Duel.SelectMatchingCard(tp, c27821104.tfilter, tp, LOCATION_DECK, 0, 1, 1, nil, atk, tc:GetCode(), e, tp)
    if sg:GetCount() > 0 then
        Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
    elseif c27821104.could_be_in_deck(atk, tc:GetCode()) then
        -- Nothing to summon, and public information cannot rule out a fitting monster:
        -- the opponent may check the deck (old rulings: Charge of the Light Brigade 09/10/22,
        -- Gravekeeper's Spy 09/04/02). A deck confirmation is only sent to the named player,
        -- so show it to both.
        local cg = Duel.GetFieldGroup(tp, LOCATION_DECK, 0)
        Duel.ConfirmCards(1 - tp, cg)
        Duel.ConfirmCards(tp, cg)
        Duel.ShuffleDeck(tp)
    end
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetOperation(c27821104.desop)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
    e1:SetCountLimit(1)
    tc:RegisterEffect(e1)
end
function c27821104.desop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Destroy(e:GetHandler(), REASON_EFFECT)
end

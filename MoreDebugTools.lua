--- STEAMODDED HEADER
--- MOD_NAME: More Debug Tools
--- MOD_ID: MoreDebugTools
--- MOD_AUTHOR: [Horsen]
--- MOD_DESCRIPTION: 在Debug菜单中添加更多功能 Add more tools in debug menu

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.MoreDebugTools()
  -- 增加小丑牌槽位
  function add_joker_slots(num)
    G.jokers.config.card_limit = G.jokers.config.card_limit + num
  end

  -- 增加消耗牌槽位
  function add_consumable_slots(num)
    G.consumeables.config.card_limit = G.consumeables.config.card_limit + num
  end

  -- 增加手牌上限
  function add_hand_size(num)
    G.hand:change_size(num)
  end

  -- 修改并汉化Debug菜单
  function create_UIBox_debug_tools()
    G.debug_tool_config = G.debug_tool_config or {}
    G.FUNCS.DT_add_money_1 = function() if G.STAGE == G.STAGES.RUN then ease_dollars(1) end end
    G.FUNCS.DT_add_money_2 = function() if G.STAGE == G.STAGES.RUN then ease_dollars(2) end end
    G.FUNCS.DT_add_money_5 = function() if G.STAGE == G.STAGES.RUN then ease_dollars(5) end end
    G.FUNCS.DT_add_money_10 = function() if G.STAGE == G.STAGES.RUN then ease_dollars(10) end end
    G.FUNCS.DT_add_round = function() if G.STAGE == G.STAGES.RUN then ease_round(1) end end
    G.FUNCS.DT_add_ante = function() if G.STAGE == G.STAGES.RUN then ease_ante(1) end end
    G.FUNCS.DT_add_hand = function() if G.STAGE == G.STAGES.RUN then ease_hands_played(1) end end
    G.FUNCS.DT_add_joker_slot = function() if G.STAGE == G.STAGES.RUN then add_joker_slots(1) end end
    G.FUNCS.DT_add_consumable_slot = function() if G.STAGE == G.STAGES.RUN then add_consumable_slots(1) end end
    G.FUNCS.DT_add_hand_size = function() if G.STAGE == G.STAGES.RUN then add_hand_size(1) end end
    G.FUNCS.DT_add_discard = function() if G.STAGE == G.STAGES.RUN then ease_discard(1) end end
    G.FUNCS.DT_reroll_boss = function()
      if G.STAGE == G.STAGES.RUN and G.blind_select_opts then
        G.from_boss_tag = true; G.FUNCS.reroll_boss(); G.from_boss_tag = nil
      end
    end
    G.FUNCS.DT_toggle_background = function() G.debug_background_toggle = not G.debug_background_toggle end
    G.FUNCS.DT_add_chips = function()
      if G.STAGE == G.STAGES.RUN then
        update_hand_text({ delay = 0 }, { chips = 10 + G.GAME.current_round.current_hand.chips }); play_sound('chips1')
      end
    end
    G.FUNCS.DT_add_mult = function()
      if G.STAGE == G.STAGES.RUN then
        update_hand_text({ delay = 0 }, { mult = 10 + G.GAME.current_round.current_hand.mult }); play_sound('multhit1')
      end
    end
    G.FUNCS.DT_x_chips = function()
      if G.STAGE == G.STAGES.RUN then
        update_hand_text({ delay = 0 }, { chips = 2 * G.GAME.current_round.current_hand.chips }); play_sound('chips1')
      end
    end
    G.FUNCS.DT_x_mult = function()
      if G.STAGE == G.STAGES.RUN then
        update_hand_text({ delay = 0 }, { mult = 10 * G.GAME.current_round.current_hand.mult }); play_sound('multhit2')
      end
    end
    G.FUNCS.DT_chip_mult_reset = function()
      if G.STAGE == G.STAGES.RUN then
        update_hand_text({ delay = 0 },
          { mult = 0, chips = 0 })
      end
    end
    G.FUNCS.DT_win_game = function() if G.STAGE == G.STAGES.RUN then win_game() end end
    G.FUNCS.DT_lose_game = function()
      if G.STAGE == G.STAGES.RUN then
        G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false
      end
    end
    G.FUNCS.DT_jimbo_toggle = function()
      if G.DT_jimbo then
        if G.DT_jimbo.children.particles.states.visible then
          if G.DT_jimbo.children.card.states.visible then
            G.DT_jimbo.children.card.states.visible = false
          else
            G.DT_jimbo.children.card.states.visible = true
            G.DT_jimbo.children.particles.states.visible = false
          end
        else
          G.DT_jimbo:remove()
          G.DT_jimbo = nil
          if G.SPLASH_LOGO then
            G.SPLASH_LOGO.states.visible = true
            if G.title_top and G.title_top.cards[1] then G.title_top.cards[1].states.visible = true end
          end
        end
      else
        if G.SPLASH_LOGO then
          G.SPLASH_LOGO.states.visible = false
          if G.title_top and G.title_top.cards[1] then G.title_top.cards[1].states.visible = false end
        end
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          blockable = false,
          func = function()
            G.DT_jimbo = Card_Character({ x = G.ROOM.T.w / 2, y = G.ROOM.T.h / 2 })

            G.DT_jimbo:set_alignment {
              major = G.ROOM_ATTACH,
              type = 'cm'
            }
            return true
          end
        }))
      end
    end
    G.FUNCS.DT_jimbo_talk = function()
      if G.DT_jimbo then
        G.DT_jimbo:add_speech_bubble({
          "                             ",
          "           ",
          "           ",
        }, 'cr')
        G.DT_jimbo:say_stuff(4)
      end
    end

    local t = {
      n = G.UIT.ROOT,
      config = { align = 'cm', r = 0.1 },
      nodes = {
        UIBox_dyn_container({
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.05 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  { n = G.UIT.T, config = { text = "打开收藏，将鼠标悬停在一张牌上", scale = 0.25, colour = G.C.WHITE, shadow = true } }
                }
              },
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  { n = G.UIT.T, config = { text = "然后按以下键：", scale = 0.25, colour = G.C.WHITE, shadow = true } }
                }
              },
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  {
                    n = G.UIT.C,
                    config = { align = "cm", padding = 0.05, colour = G.C.BLUE, emboss = 0.05, r = 0.1 },
                    nodes = {
                      { n = G.UIT.T, config = { text = "[1] 解锁该牌", scale = 0.25, colour = G.C.WHITE } }
                    }
                  },
                  {
                    n = G.UIT.C,
                    config = { align = "cm", padding = 0.05, colour = G.C.BLUE, emboss = 0.05, r = 0.1 },
                    nodes = {
                      { n = G.UIT.T, config = { text = "[2] 发现该牌", scale = 0.25, colour = G.C.WHITE } }
                    }
                  },
                  {
                    n = G.UIT.C,
                    config = { align = "cm", padding = 0.05, colour = G.C.BLUE, emboss = 0.05, r = 0.1 },
                    nodes = {
                      { n = G.UIT.T, config = { text = "[3] 生成该牌", scale = 0.25, colour = G.C.WHITE } }
                    }
                  }
                }
              }
            }
          },
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.05 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  { n = G.UIT.T, config = { text = "将鼠标悬停在任意小丑牌或手牌上", scale = 0.25, colour = G.C.WHITE, shadow = true } }
                }
              },
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  { n = G.UIT.T, config = { text = "按下 [Q] 切换工艺", scale = 0.25, colour = G.C.WHITE, shadow = true } }
                }
              },
            }
          },
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.05 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  { n = G.UIT.T, config = { text = "按下 [H] 只显示背景", scale = 0.25, colour = G.C.WHITE, shadow = true } }
                }
              },
            }
          },
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.05 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  { n = G.UIT.T, config = { text = "按下 [J] 播放开屏动画", scale = 0.25, colour = G.C.WHITE, shadow = true } }
                }
              },
            }
          },
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.05 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  { n = G.UIT.T, config = { text = "按下 [8] 隐藏光标", scale = 0.25, colour = G.C.WHITE, shadow = true } }
                }
              },
            }
          },
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.05 },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                  { n = G.UIT.T, config = { text = "按下 [9] 隐藏提示悬浮窗", scale = 0.25, colour = G.C.WHITE, shadow = true } }
                }
              },
            }
          },
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.15 },
            nodes = {
              {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.15 },
                nodes = {
                  UIBox_button { label = { "+$1" }, button = "DT_add_money_1", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.MONEY },
                  UIBox_button { label = { "+$2" }, button = "DT_add_money_2", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.MONEY },
                  UIBox_button { label = { "+$5" }, button = "DT_add_money_5", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.MONEY },
                  UIBox_button { label = { "+$10" }, button = "DT_add_money_10", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.MONEY },
                  UIBox_button { label = { "+1出牌次数" }, button = "DT_add_hand", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.BLUE },
                  UIBox_button { label = { "+1弃牌次数" }, button = "DT_add_discard", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.RED },
                  UIBox_button { label = { "+1底注" }, button = "DT_add_ante", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.ORANGE },
                  UIBox_button { label = { "+1回合" }, button = "DT_add_round", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.ORANGE },
                  UIBox_button { label = { "+1小丑牌槽位" }, button = "DT_add_joker_slot", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.GREEN },
                  UIBox_button { label = { "+1消耗牌槽位" }, button = "DT_add_consumable_slot", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.GREEN },
                  UIBox_button { label = { "+1手牌上限" }, button = "DT_add_hand_size", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.GREEN },
                }
              },
              {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.15 },
                nodes = {
                  UIBox_button { label = { "+10筹码" }, button = "DT_add_chips", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.CHIPS },
                  UIBox_button { label = { "X2筹码" }, button = "DT_x_chips", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.CHIPS },
                  UIBox_button { label = { "+10倍率" }, button = "DT_add_mult", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.MULT },
                  UIBox_button { label = { "X10倍率" }, button = "DT_x_mult", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.MULT },
                  UIBox_button { label = { "重制筹码倍率" }, button = "DT_chip_mult_reset", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.ORANGE },
                  UIBox_button { label = { "重掷Boss" }, button = "DT_reroll_boss", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.PURPLE },
                  UIBox_button { label = { "直接获胜" }, button = "DT_win_game", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.BLUE },
                  UIBox_button { label = { "直接失败" }, button = "DT_lose_game", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.RED },
                  UIBox_button { label = { "去除背景" }, button = "DT_toggle_background", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.GREY },
                  UIBox_button { label = { "显示金宝" }, button = "DT_jimbo_toggle", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.GREY },
                  UIBox_button { label = { "金宝说话" }, button = "DT_jimbo_talk", minw = 1.7, minh = 0.4, scale = 0.35, colour = G.C.GREY },
                }
              }
            }
          }
        }, true)
      }
    }
    return t
  end

  -- 显示或隐藏Debug菜单
  function show_or_hide_debug_menu()
    if G.SETTINGS.show_debug_menu and not G.debug_tools then
      G.debug_tools = UIBox {
        definition = create_UIBox_debug_tools(),
        config = { align = 'cr', offset = { x = G.ROOM.T.x + 11, y = 0 }, major = G.ROOM_ATTACH, bond = 'Weak' }
      }
      G.E_MANAGER:add_event(Event({
        blockable = false,
        func = function()
          G.debug_tools.alignment.offset.x = -4
          return true
        end
      }))
    elseif not G.SETTINGS.show_debug_menu and G.debug_tools then
      G.debug_tools:remove()
      G.debug_tools = nil
    end
  end

  -- 修改设置菜单
  local settings_tab_ref = G.UIDEF.settings_tab
  function G.UIDEF.settings_tab(tab)
    local t = settings_tab_ref(tab)
    if tab == 'Game' then
      -- 添加按钮
      table.insert(t.nodes, -1, create_toggle({
        label = "显示Debug菜单",
        ref_table = G.SETTINGS,
        ref_value = "show_debug_menu",
        callback = show_or_hide_debug_menu
      }))
    end
    return t
  end
end

----------------------------------------------
------------MOD CODE END----------------------

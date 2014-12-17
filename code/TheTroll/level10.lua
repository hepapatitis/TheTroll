-----------------------------------------------------------------------------------------
--
-- level10.lua
-- By		: Stephanus Yanaputra
-- Version	: 1.0
--
-----------------------------------------------------------------------------------------
local game_scene_block_group
local question_block_group
local next_button_group

local game_bg
local question_text
local question_text_2
local question_text_3
local question_window
local question_label
local answer_text_1
local answer_text_2
local answer_text_3
local answer_text_4
local answer_window_1
local answer_window_2
local answer_window_3
local answer_window_4
local next_button

local q_set
local a_set
local chosen_set_idx

local current_lv = 10

function init_level10()
	print("Init Lv: " .. current_lv)
	
	function create_question()
		game_scene_block_group = display.newGroup()
		
		next_button_group = display.newGroup()
		next_button_group.x = phone_width
		
		question_block_group = display.newGroup()
		question_block_group.x = phone_width
		
		q_set = {
			[1] = "..he buy an ice cream..",
			[2] = "Once upon a time, there",
			[3] = "is a farmer named Alan. ",
			[4] = "..but nobody realized that.",
		}
		a_set = {
			[1] = "4",
			[2] = "0",
			[3] = "1",
			[4] = "3",
		}
		
		local random_selection = math.random(1,4)
		chosen_set_idx = random_selection
		print("Selected: " .. chosen_set_idx)
		
		-- Create Background
		game_bg =  display.newImageRect( game_scene_block_group, ASSET_FOLDER .. "bg01.png", bg_width, bg_height )
		game_bg.x = phone_middle_x
		game_bg.y = phone_middle_y

		
		
		-- Create Question Window
		question_window = display.newImageRect( question_block_group, ASSET_FOLDER .. "question-window.png", 536 * 0.5, 426 * 0.5 )
		question_window.x = phone_middle_x
		question_window.y = q_window_middle_point_y
		
		-- Create Question Text
		question_text = display.newText( question_block_group, q_set[random_selection], phone_middle_x, q_window_middle_point_y +15, DEFAULT_FONT, 20 )
		question_text_2 = display.newText( question_block_group, "Take a look at", phone_middle_x, q_window_middle_point_y - 35, DEFAULT_FONT, 20 )
		question_label = display.newText( question_block_group, "No. "..current_lv, phone_middle_x, q_window_middle_point_y - 85, DEFAULT_FONT, 24 )
		
		-- Create Next Button
		next_button = display.newImageRect( next_button_group, ASSET_FOLDER .. "answer-window.png", answer_window_width, answer_window_height )
		next_button.x = phone_middle_x
		next_button.y = q_answer_middle_point_y_1
		next_button:addEventListener("tap", proceed_next)
		
		next_button_text = display.newText( next_button_group, "Next", next_button.x, next_button.y, DEFAULT_FONT, 24 )
		
		
		-- Create Answer Window
		answer_window_1 = display.newImageRect( game_scene_block_group, ASSET_FOLDER .. "answer-window.png", answer_window_width, answer_window_height )
		answer_window_1.x = q_answer_middle_point_x_1z
		answer_window_1.y = q_answer_middle_point_y_1
		answer_window_1.idx = 1
		answer_window_1:addEventListener("tap", check_answer)
		
		answer_window_2 = display.newImageRect( game_scene_block_group, ASSET_FOLDER .. "answer-window.png", answer_window_width, answer_window_height )
		answer_window_2.x = q_answer_middle_point_x_1z
		answer_window_2.y = q_answer_middle_point_y_2
		answer_window_2.idx = 2
		answer_window_2:addEventListener("tap", check_answer)
		
		answer_window_3 = display.newImageRect( game_scene_block_group, ASSET_FOLDER .. "answer-window.png", answer_window_width, answer_window_height )
		answer_window_3.x = q_answer_middle_point_x_2z
		answer_window_3.y = q_answer_middle_point_y_1
		answer_window_3.idx = 3
		answer_window_3:addEventListener("tap", check_answer)
		
		answer_window_4 = display.newImageRect( game_scene_block_group, ASSET_FOLDER .. "answer-window.png", answer_window_width, answer_window_height )
		answer_window_4.x = q_answer_middle_point_x_2z
		answer_window_4.y = q_answer_middle_point_y_2
		answer_window_4.idx = 4
		answer_window_4:addEventListener("tap", check_answer)
		
		-- Create Answer Text
		answer_text_1 = display.newText( game_scene_block_group, a_set[1], q_answer_middle_point_x_1z, q_answer_middle_point_y_1, DEFAULT_FONT, 24 )
		answer_text_2 = display.newText( game_scene_block_group, a_set[2], q_answer_middle_point_x_1z, q_answer_middle_point_y_2, DEFAULT_FONT, 24 )
		answer_text_3 = display.newText( game_scene_block_group, a_set[3], q_answer_middle_point_x_2z, q_answer_middle_point_y_1, DEFAULT_FONT, 24 )
		answer_text_4 = display.newText( game_scene_block_group, a_set[4], q_answer_middle_point_x_2z, q_answer_middle_point_y_2, DEFAULT_FONT, 24 )
		
		-- Start Showing using Animation
		transition.to( next_button_group, { time = q_animation_speed_1, x = q_move_amount, delta=true, transition=easing.outBack } )
		transition.to( question_block_group, { time = q_animation_speed, x = q_move_amount, delta=true, transition=easing.outBack } )
	end

	function proceed_next()
		-- Hide Button
		transition.to( next_button_group, { time = q_animation_speed, x = q_move_amount, delta=true, transition=easing.outBack } )
		
		-- Hide & Show Text
		question_text.isVisible = false
		question_text_2.isVisible = false
		
		question_text_3 = display.newText( question_block_group, "How many '.' was there?", phone_middle_x, q_window_middle_point_y, DEFAULT_FONT, 19 )
		
		
		-- Show Answer
		transition.to( answer_window_1	, { time = q_animation_speed_1, x = q_move_amount, delta=true, transition=easing.outBack } )
		transition.to( answer_text_1	, { time = q_animation_speed_1, x = q_move_amount, delta=true, transition=easing.outBack } )
		transition.to( answer_window_2	, { time = q_animation_speed_2, x = q_move_amount, delta=true, transition=easing.outBack } )
		transition.to( answer_text_2	, { time = q_animation_speed_2, x = q_move_amount, delta=true, transition=easing.outBack } )
		transition.to( answer_window_3	, { time = q_animation_speed_3, x = q_move_amount, delta=true, transition=easing.outBack } )
		transition.to( answer_text_3	, { time = q_animation_speed_3, x = q_move_amount, delta=true, transition=easing.outBack } )
		transition.to( answer_window_4	, { time = q_animation_speed_4, x = q_move_amount, delta=true, transition=easing.outBack } )
		transition.to( answer_text_4	, { time = q_animation_speed_4, x = q_move_amount, delta=true, transition=easing.outBack } )
	end

	function check_answer(event)
		if event.target.idx == chosen_set_idx then
			print("Correct")
			--Remove Question 1
			remove_question()
			
			--require("level11")
			--init_level11()
			require ("gamedone")
			init_gamedone(current_lv)
		else
			-- Game Over
			remove_question()
			print("Wrong!")
			require ("gameover")
			init_gameover(current_lv)
		end
	end

	function remove_question()
		game_scene_block_group.isVisible = true
		
		display.remove(game_bg)
		
		display.remove(question_text)
		display.remove(question_text_2)
		display.remove(question_text_3)
		display.remove(question_window)
		display.remove(question_label)
		
		display.remove(answer_window_1)
		display.remove(answer_window_2)
		display.remove(answer_window_3)
		display.remove(answer_window_4)
		
		display.remove(answer_text_1)
		display.remove(answer_text_2)
		display.remove(answer_text_3)
		display.remove(answer_text_4)
		
		display.remove(next_button)
		display.remove(next_button_text)
		
		display.remove(next_button_group)
		display.remove(question_block_group)
		display.remove(game_scene_block_group)
	end
	
	create_question()
	update_progress(current_lv)
end
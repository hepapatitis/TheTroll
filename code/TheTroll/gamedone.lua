-----------------------------------------------------------------------------------------
--
-- gamedone.lua
-- By		: Stephanus Yanaputra
-- Version	: 1.0
--
-----------------------------------------------------------------------------------------
local game_scene_block_group

local game_bg
local question_text
local question_text_2
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

local level

function init_gamedone(lv)
	level = lv
	create_gamedone()
end

function create_gamedone()
	game_scene_group = display.newGroup()
	game_scene_block_group = display.newGroup()
	
	-- Create Background
	game_bg =  display.newImageRect( game_scene_block_group, ASSET_FOLDER .. "bg01.png", bg_width, bg_height )
	game_bg.x = phone_middle_x
	game_bg.y = phone_middle_y

	-- Create Question Window
	question_window = display.newImageRect( game_scene_block_group, ASSET_FOLDER .. "question-window.png", 536 * 0.5, 426 * 0.5 )
	question_window.x = phone_middle_x
	question_window.y = q_window_middle_point_y
	
	-- Create Question Text
	question_text = display.newText( game_scene_block_group, "Last Level: "..level, phone_middle_x, q_window_middle_point_y +15, DEFAULT_FONT, 25 )
	question_text_2 = display.newText( game_scene_block_group, "You've finished the whole level", phone_middle_x, q_window_middle_point_y - 35, DEFAULT_FONT, 18 )
	question_label = display.newText( game_scene_block_group, "Congratulation!", phone_middle_x, q_window_middle_point_y - 85, DEFAULT_FONT, 21 )
	
	-- Create Next Button
	next_button = display.newImageRect( game_scene_block_group, ASSET_FOLDER .. "answer-window.png", answer_window_width, answer_window_height )
	next_button.x = phone_middle_x
	next_button.y = q_answer_middle_point_y_1
	next_button:addEventListener("tap", proceed_main_menu)
	
	next_button_text = display.newText( game_scene_block_group, "Main Menu", next_button.x, next_button.y, DEFAULT_FONT, 24 )
	
	function proceed_main_menu()
		remove_gamedone()
		create_splash_screen()
	end
	
	function remove_gamedone()
		display.remove(game_bg)
		
		display.remove(question_window)
		display.remove(question_text)
		display.remove(question_text_2)
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
		
		display.remove(game_scene_block_group)
	end
end
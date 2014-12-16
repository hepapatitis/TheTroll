-----------------------------------------------------------------------------------------
--
-- main.lua
-- By		: Stephanus Yanaputra
-- Version	: 2.0
--
-----------------------------------------------------------------------------------------
-- TABLE OF CONTENTS
--
-- SPLASH SCREEN 		(#splashscreen)
-- CREDITS SCREEN 		(#creditsscreen)
-- GAME SCREEN 			(#gamescreen)
-- GAME OVER SCREEN 	(#gameoverscreen)
--
-----------------------------------------------------------------------------------------

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):
display.setStatusBar( display.HiddenStatusBar )

-- ASSETS FOLDERS
ASSET_FOLDER = "assets/"
ASSET_FOLDER_SOUND = ASSET_FOLDER .. "sounds/"

-- GLOBAL VARIABLES
sceneGroup = display.newGroup()
bg_width = 360
bg_height = 570
phone_width = display.contentWidth
phone_height = display.contentHeight
phone_middle_x = phone_width/2
phone_middle_y = phone_height/2
score_file = "scorefile.txt"
swipe_sensitivity = 20
DEFAULT_FONT = "Otaku Rant"
answer_window_width = 252 * 0.5
answer_window_height = 122 * 0.5

q_window_middle_point_y = phone_middle_y - 80
q_answer_middle_point_x_1 = phone_middle_x - 70
q_answer_middle_point_x_2 = phone_middle_x + 70
q_answer_middle_point_y_1 = phone_middle_y + 75
q_answer_middle_point_y_2 = phone_middle_y + 150

-- AUDIO & SOUNDS
audio_menu_click = audio.loadSound( ASSET_FOLDER_SOUND .. "select_menu_click/menu_click.wav" )
audio_plus_point = audio.loadSound( ASSET_FOLDER_SOUND .. "score_plus/score_plus.wav" )
audio_minus_point = audio.loadSound( ASSET_FOLDER_SOUND .. "score_minus/score_minus.wav" )
audio_swipe = {
    swipe1 = audio.loadSound( ASSET_FOLDER_SOUND .. "swipe_squares/whip_01.wav" ),
    swipe2 = audio.loadSound( ASSET_FOLDER_SOUND .. "swipe_squares/whip_02.wav" ),
    swipe3 = audio.loadSound( ASSET_FOLDER_SOUND .. "swipe_squares/whip_03.wav" ),
    swipe4 = audio.loadSound( ASSET_FOLDER_SOUND .. "swipe_squares/whip_04.wav" ),
    swipe5 = audio.loadSound( ASSET_FOLDER_SOUND .. "swipe_squares/whip_05.wav" ),
    swipe6 = audio.loadSound( ASSET_FOLDER_SOUND .. "swipe_squares/whip_06.wav" )
}

-- Score Functions
high_score = 0
last_game_score = 0

function create_high_score_file()
	local path = system.pathForFile( score_file, system.DocumentsDirectory)
	local contents = "0"
	local file = io.open( path, "w" )
	file:write( contents )
	io.close( file )
	print("New Score File created: ", score_file, ".")
	return true
end

function save_high_score()
	local path = system.pathForFile( score_file, system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = tostring( high_score )
        file:write( contents )
        io.close( file )
		print("Saved! Score is: " .. high_score)
        return true
    else
		local contents = tostring( high_score )
		file = io.open( path, "w" )
		file:write( contents )
		io.close( file )
    	print("Error: could not read ", score_file, ".")
        return false
    end
end

function load_high_score()
    local path = system.pathForFile( score_file, system.DocumentsDirectory)
    local contents = ""
    local file = io.open( path, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        local score = tonumber(contents);
        io.close( file )
		print("Load! Score is: " .. score)
        return score
	else
		create_high_score_file()
        return 0
    end
	
    print("Could not read scores from ", score_file, ".")
    return 0
end

-- SPLASH SCREEN - #splashscreen
-----------------------------------------------------------------------------------------
local splash_bg
local splash_logo
local splash_highscore_container
local splash_play_btn
local splash_credits_btn
local splash_scene_group
local splash_high_score_text

function create_splash_screen() 
	splash_scene_group = display.newGroup()
	
	splash_bg =  display.newImageRect( splash_scene_group, ASSET_FOLDER .. "bg01.png", bg_width, bg_height )
	splash_bg.x = phone_middle_x
	splash_bg.y = phone_middle_y
	
	splash_logo =  display.newImageRect( splash_scene_group, ASSET_FOLDER .. "troll-test-logo.png", 206, 132)
	splash_logo.x = phone_middle_x
	splash_logo.y = phone_middle_y - 100
	
	local btn_width = 64
	local btn_height = 64

	splash_play_btn =  display.newImageRect( splash_scene_group, ASSET_FOLDER .. "btn-play.png", btn_width, btn_height )
	splash_play_btn.x = phone_middle_x
	splash_play_btn.y = phone_middle_y + 70
	splash_play_btn:toFront()
		
	local function onTap_scene_game( event )
		create_game_screen()
		remove_splash_screen()
		audio.play(audio_menu_click)
		return true
	end
	splash_play_btn:addEventListener( "tap", onTap_scene_game )
	
	--splash_highscore_container =  display.newImageRect( splash_scene_group, ASSET_FOLDER .. "hiscore_banner.png", phone_width, 55 )
	--splash_highscore_container.x = phone_middle_x
	--splash_highscore_container.y = phone_middle_y - 20
	
	high_score = load_high_score()
	local splash_highscore_text_options = 
	{  
		text = high_score,
		parent = splash_scene_group,
		x = phone_middle_x + 100,
		y = phone_middle_y - 20,
		width = phone_width,
		font = DEFAULT_FONT,   
		fontSize = 25,
		align = "center"  --new alignment parameter
	}
	splash_high_score_text = display.newText(splash_highscore_text_options)
end

function remove_splash_screen()
	display.remove(splash_bg);
	--display.remove(splash_highscore_container);
	display.remove(splash_play_btn);
	--display.remove(splash_credits_btn);
	display.remove(splash_high_score_text);
	display.remove(splash_scene_group);
end

-- GAME SCREEN - #gamescreen
-----------------------------------------------------------------------------------------
local game_scene_group
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

local q_set
local a_set
local chosen_set_idx

local q_window_middle_point_y = phone_middle_y - 80
local q_answer_middle_point_x_1 = phone_middle_x - 70
local q_answer_middle_point_x_2 = phone_middle_x + 70
local q_answer_middle_point_y_1 = phone_middle_y + 75
local q_answer_middle_point_y_2 = phone_middle_y + 150

-- Start & Pause & Resume Game
local function start_game()
	game_timer = timer.performWithDelay( TIMER_FPS, game_loop, 0 )
	game_loop()
	game_is_paused = 0
end

local function pause_game()
	local result = timer.pause(game_timer)
	create_pause_screen()
	game_is_paused = 1
end

local function resume_game()
	timer.resume(game_timer)
	game_is_paused = 0
end

-- Game Over Game Function
local function game_over()
	timer.cancel(game_timer)
	create_gameover_screen()
end

function create_game_screen()
	--create_question_1()
	require ("level1")
	init_level1()
end

function remove_game_screen()
	
end

-- CREDITS SCREEN - #creditsscreen
-----------------------------------------------------------------------------------------
local credits
local credits_scene_group
function create_credits_screen()
	splash_scene_group = display.newGroup()
	
	credits = display.newImageRect( splash_scene_group, ASSET_FOLDER .. "credits_scene.png", phone_width, phone_height )
	credits.x = phone_middle_x
	credits.y = phone_middle_y
	
	local function onTap_scene_splash( event )
		remove_credits_screen()
		audio.play(audio_menu_click)
		return true
	end
	credits:addEventListener( "tap", onTap_scene_splash )
end

function remove_credits_screen()
	display.remove(credits);
	display.remove(credits_scene_group);
end

-- PAUSE SCREEN - #pausescreen
-----------------------------------------------------------------------------------------
local pause_overlay
local pause_btn_play
local pause_btn_resume
local pause_btn_main_menu
local pause_box
local pause_scene_group
function create_pause_screen()
	pause_scene_group = display.newGroup()
	
	pause_overlay = display.newRect( pause_scene_group, phone_middle_x, phone_middle_y, phone_width, phone_height+100)
	pause_overlay:setFillColor(0,0,0)
	pause_overlay.alpha = 0.5
	pause_overlay:addEventListener("touch", function() return true end)
	pause_overlay:addEventListener("tap", function() return true end)
	
	pause_btn_play = display.newImageRect( pause_scene_group, ASSET_FOLDER .. "btn-play.png", 50, 50 )
	pause_btn_play.x = phone_width - 25
	pause_btn_play.y = 25
	
	pause_box =  display.newImageRect( pause_scene_group, ASSET_FOLDER .. "pause_btn_bg.png", 260, 340 )
	pause_box.x = phone_middle_x
	pause_box.y = phone_middle_y
		
	pause_btn_resume =  display.newImageRect( pause_scene_group, ASSET_FOLDER .. "btn_resume.png", 200, 85 )
	pause_btn_resume.x = phone_middle_x
	pause_btn_resume.y = phone_middle_y + 5
	
	pause_btn_main_menu =  display.newImageRect( pause_scene_group, ASSET_FOLDER .. "btn_main_menu_2.png", 200, 85 )
	pause_btn_main_menu.x = phone_middle_x
	pause_btn_main_menu.y = phone_middle_y + 100
	
	
	local function btnTapBack(event)
		remove_pause_screen()
		resume_game()
		return true
	end
	pause_btn_play:addEventListener("tap", btnTapBack)
	pause_btn_resume:addEventListener("tap", btnTapBack)

	local function btnTapMainMenu(event)
		remove_pause_screen()
		remove_game_screen()
		create_splash_screen()
		return true
	end
	pause_btn_main_menu:addEventListener("tap", btnTapMainMenu)
	
end

function remove_pause_screen()
	display.remove(pause_overlay);
	display.remove(pause_btn_play);
	display.remove(pause_btn_resume);
	display.remove(pause_btn_main_menu);
	display.remove(pause_box);
end


-- GAME OVER SCREEN - #gameoverscreen
-----------------------------------------------------------------------------------------
local gameover_overlay
local gameover_btn_main_menu
local gameover_box
local gameover_highscore_text
local gameover_lastscore_text
local gameover_scene_group
function create_gameover_screen()
	local btn_main_menu_width = 200
	local btn_main_menu_height = 50
	
	gameover_scene_group = display.newGroup()

	gameover_overlay = display.newRect( gameover_scene_group, phone_middle_x, phone_middle_y, phone_width, phone_height+100)
	gameover_overlay:setFillColor(0,0,0)
	gameover_overlay.alpha = 0.5
	gameover_overlay:addEventListener("touch", function() return true end)
	gameover_overlay:addEventListener("tap", function() return true end)
	
	gameover_box =  display.newImageRect( gameover_scene_group, ASSET_FOLDER .. "game_over_scene.png", 260, 340 )
	gameover_box.x = phone_middle_x
	gameover_box.y = phone_middle_y
	
	gameover_btn_main_menu =  display.newImageRect( gameover_scene_group, ASSET_FOLDER .. "btn-main-menu.png", btn_main_menu_width, btn_main_menu_height )
	gameover_btn_main_menu.x = phone_middle_x
	gameover_btn_main_menu.y = phone_middle_y + 118
	
	local function btnTapMainMenu(event)
		create_splash_screen()
		remove_gameover_screen()
		return true
	end
	gameover_btn_main_menu:addEventListener("tap", btnTapMainMenu)
	
	if high_score < last_game_score then
		high_score = last_game_score
		save_high_score()
	end
	
	local gameover_highscore_text_options = 
	{  
		text = high_score,
		parent = gameover_scene_group,
		x = display.contentCenterX,
		y = phone_middle_y + 68,
		width = btn_main_menu_width,     --required for multi-line and alignment
		font = native.systemFontBold,   
		fontSize = 30,
		align = "right"  --new alignment parameter
	}
	gameover_highscore_text = display.newText( gameover_highscore_text_options )
	
	local gameover_lastscore_text_options = 
	{  
		text = last_game_score,
		parent = gameover_scene_group,
		x = display.contentCenterX,
		y = phone_middle_y + 21,
		width = btn_main_menu_width,     --required for multi-line and alignment
		font = native.systemFontBold,   
		fontSize = 38,
		align = "right"  --new alignment parameter
	}
	gameover_lastscore_text = display.newText( gameover_lastscore_text_options )
end

function remove_gameover_screen()
	display.remove(gameover_overlay);
	display.remove(gameover_btn_main_menu);
	display.remove(gameover_box);
	display.remove(gameover_highscore_text);
	display.remove(gameover_lastscore_text);
	
	remove_game_screen()
end


-- Let's Start the game
create_splash_screen() 
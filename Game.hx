

//-------------------------
// Janicki Michel Aout 2013
//-------------------------




import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.filters.GlowFilter;

import flash.media.SoundMixer;



enum State { Intro; Play; Credits; }


@:bitmap("splash.png")	class SPLASH_EMBED extends flash.display.BitmapData { }	
@:bitmap("credits.png")	class CREDIT_EMBED extends flash.display.BitmapData { }


class Game extends Sprite
{

	static var	music_intro;
	static var	music_credits;
	static var	music_game;
	static var	bruit_1;
	static var	bruit_select;
	static var	bruit_hit;
	static var	bruit_next;

	
	var Splash:				Bitmap;
	var Credits:			Bitmap;
	
	var DrawView:			BitmapData;
	var GameState:			State;
	var Graphics:			_Draw;
   
	var KeyDown:			Array<Bool>;

	var	ScaleText:			Float;	
	

	var HudText:			TextField;
	var MenuPlayText:		TextField;
	var MenuCreditsText:	TextField;
	var NextLevelText:		TextField;

	var MenuSelect:			Int;
	
	var heroX :				Int;
	var heroY :				Int;
	var scrollX :			Int;
	var scrollY :			Int;
	var	heroFlash:			Int;
	var	heroDead:			Bool;
	var	heroWin:			Bool;
	var heroDeadGravity:	Float;
	
	var explo_x: 			Int;
	var explo_y: 			Int;
	var explo_tempo:		Int;
	var explo_frame:		Int;
	var	explo_flag:			Bool;

	var NextLevelTick:		Int;
	var NextLevelX:			Int;
	var NextLevelY:			Int;
	var NextLevelDepY:		Float;
	
	
	var	shiftX:				Int;
	var shiftY:				Int;
	var col:				Int;
	var colH:				Int;
	var colB:				Int;
	var colD:				Int;
	var colG:				Int;

	var anim: 				Int;
	var tanim: 				Int;
	var dirhero:			Int;
	var old_dirhero:		Int;

	var NbItem:				Int;
	
		

	var GameLevel:			Int;
	var TotalObjects:		Int;
	
	var LevelMap:			Array<Array<Int>>;
	var LevelAnim:			Array<Array<Int>>;
	var LevelObjects:		Array<Array<Int>>;

	
//------------------------------ constants --------------------------------	


	static var Res_Width :		Int	= 240;
	static var Res_Height:		Int	= 240;


	static var BLOCKSIZEX:		Int = 16;
	static var BLOCKSIZEY:		Int = 16;
	static var MAPSIZEX:		Int = 20;
	static var MAPSIZEY:		Int = 20;

	
	static var ANIM_INDEX: 		Int	= 0;		// INDEX ANIMATION
	static var ANIM_ID:			Int	= 1;		// CURRENT TILE ANIMATED
	static var ANIM_FRAME:		Int	= 2;		// FRAME CALC
	static var ANIM_AFRAME:		Int	= 3;		// FRAME CALC
	static var ANIM_DELAY:		Int	= 4;		// DELAY ANIMATION
	static var ANIM_ASIZE:		Int	= 5;		// STRUCT SIZEOF 

	
	static var OBJ_FLAG:		Int	= 0;		// ON-OFF
	static var OBJ_POSX:		Int	= 1;		// POSX 
	static var OBJ_POSY:		Int	= 2;		// POSY
	static var OBJ_TYPE:		Int	= 3;		// TYPE
	static var OBJ_FRAME:		Int	= 4;		// INDEX IMAGE FRAME
	static var OBJ_TEMPO:		Int	= 5;		// TEMPO
	static var OBJ_SHIFTX:		Int	= 6;		// SHIFT
	static var OBJ_SHIFTY	:	Int	= 7;		// SHIFT
	static var OBJ_DIR:			Int	= 8;		// DIR
	static var OBJ_CPT:			Int	= 9;		// CPT
	static var OBJ_INDEX:		Int	= 10;		// INDEX ANIMATION
	

	static var LOOP:			Int	= 0;
	static var DROITE:			Int	= 1;
	static var BAS:				Int	= 2;
	static var GAUCHE:			Int	= 3;
	static var HAUT:			Int	= 4;
	
	
static var InitMap:	Array<Array<Array<Int>>>	= [
[	
	
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
[1,4,2,2,2,2,2,4,2,2,2,2,2,4,2,2,2,2,4,1],
[1,4,2,2,4,1,1,3,1,4,2,2,2,4,2,2,2,2,4,1],
[1,1,1,4,4,1,1,3,1,4,2,4,2,2,2,4,2,1,7,1],
[1,1,1,4,1,1,1,3,1,4,2,4,1,1,1,4,1,1,1,1],
[1,1,4,4,1,4,2,4,1,3,1,4,2,2,4,2,2,2,4,1],
[1,1,6,1,1,3,1,3,1,3,1,1,2,2,4,2,1,1,3,1],
[1,1,1,1,4,4,2,4,1,7,1,1,2,4,2,4,2,1,3,1],
[1,4,4,2,4,4,1,3,1,1,1,1,1,3,1,3,1,1,6,1],
[1,4,4,1,1,1,1,4,2,2,2,2,1,7,1,4,1,1,1,1],
[1,1,3,1,1,1,1,3,1,1,1,1,1,1,2,4,2,2,4,1],
[1,1,6,1,2,2,2,4,1,2,2,4,2,2,2,2,2,2,4,1],
[1,1,1,1,1,1,1,3,1,4,2,4,2,2,2,2,2,1,7,1],
[1,2,2,2,2,2,2,4,2,4,2,2,2,2,4,2,4,2,2,1],
[1,1,1,1,1,1,1,1,1,1,1,1,1,2,4,2,2,2,4,1],
[1,1,2,4,1,1,1,1,1,1,1,1,1,1,4,2,4,2,4,1],
[1,4,2,4,2,2,2,4,2,1,1,1,1,1,1,1,4,2,1,1],
[1,6,1,4,2,2,2,4,2,2,4,2,2,2,4,2,4,2,4,1],
[1,1,1,1,1,1,1,4,2,2,4,2,1,2,4,1,1,1,7,1],
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
],
[
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
[1,2,4,2,2,2,2,2,4,2,4,2,4,2,2,2,2,2,4,1],
[1,1,3,1,1,1,1,1,3,1,3,1,3,1,1,1,1,1,3,1],
[1,1,4,2,2,4,2,1,4,2,4,2,4,2,1,3,1,1,3,1],
[1,1,3,1,1,7,1,1,6,1,3,1,7,1,1,4,2,2,4,1],
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,3,1],
[1,1,1,4,2,4,2,4,2,2,4,2,4,2,2,4,2,2,4,1],
[1,1,1,3,1,3,1,3,1,1,3,1,3,1,1,3,1,1,3,1],
[1,1,1,3,1,6,1,1,1,1,4,2,4,1,1,6,1,1,3,1],
[1,1,1,3,1,1,1,1,1,1,3,1,1,1,1,1,1,1,3,1],
[1,4,2,4,2,4,1,1,1,1,7,1,4,2,2,4,2,2,4,1],
[1,3,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
[1,4,2,2,2,4,2,2,2,4,2,2,2,2,2,2,2,2,4,1],
[1,3,1,1,1,3,1,1,1,3,1,1,1,1,1,1,1,1,6,1],
[1,7,1,1,1,3,1,1,1,4,2,2,2,4,2,2,2,2,1,1],
[1,1,1,1,2,4,1,1,1,1,1,1,1,3,1,1,1,1,1,1],
[1,1,1,1,1,3,1,2,2,2,2,4,2,4,2,2,2,4,1,1],
[1,1,1,1,1,3,1,1,1,4,2,4,2,2,2,2,2,4,1,1],
[1,1,1,1,1,6,1,1,1,7,1,1,1,1,1,1,1,1,1,1],
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
],
[
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
[1,4,2,2,2,4,2,2,2,2,2,2,2,2,4,2,2,2,4,1],
[1,1,1,1,1,3,1,1,1,1,1,1,1,1,3,1,1,1,3,1],
[1,4,2,4,1,3,1,1,1,1,1,1,1,1,1,1,1,1,3,1],
[1,3,1,6,1,3,1,1,4,2,4,2,2,2,2,2,2,2,4,1],
[1,3,1,1,1,3,1,1,3,1,3,1,1,1,1,1,1,1,3,1],
[1,4,2,4,1,3,1,1,4,2,4,2,2,4,2,2,2,2,4,1],
[1,3,1,7,1,3,1,1,3,1,3,1,1,3,1,1,1,1,3,1],
[1,3,1,1,1,3,1,1,4,1,4,2,2,4,1,1,4,1,3,1],
[1,4,2,4,1,3,1,1,7,1,6,1,1,7,1,1,3,1,3,1],
[1,3,1,6,1,3,1,1,1,1,1,4,2,2,2,2,4,4,4,1],
[1,3,1,1,1,3,1,1,1,1,1,6,1,1,1,1,1,3,1,1],
[1,4,2,4,1,4,2,2,4,2,4,2,4,2,2,4,1,3,1,1],
[1,3,1,7,1,3,1,1,3,1,3,1,3,1,1,3,1,4,4,1],
[1,3,1,1,1,4,1,1,1,1,3,1,3,1,1,3,1,3,7,1],
[1,4,2,4,1,7,1,4,2,2,4,2,4,2,2,4,1,3,1,1],
[1,4,2,4,1,1,1,1,1,1,6,1,1,1,1,7,1,4,4,1],
[1,3,1,6,1,1,1,1,1,1,1,1,1,1,1,1,1,3,6,1],
[1,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,4,1,1],
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
],

];



	static var e_explo:Array<Int>	= [9,9,10,10,11,11,12,12];

	// ANIMATIONS HERO
	static var g_hero_h:Array<Int>	= [13,14,15];
	static var g_hero_d:Array<Int>	= [16,17,18];
	static var g_hero_b:Array<Int>	= [19,20,21];
	static var g_hero_g:Array<Int>	= [22,23,24];

	// ANIMATIONS Resistance
	static var e_hero_h:Array<Int>	= [25,26,27];
	static var e_hero_d:Array<Int>	= [28,29,30];
	static var e_hero_b:Array<Int>	= [31,32,33];
	static var e_hero_g:Array<Int>	= [34,35,36];
	
	// ANIMATIONS Escargot
	static var es_hero_d:Array<Int>	= [37,38,39];
	static var es_hero_g:Array<Int>	= [40,41,42];

	
	
	// INIT ENNEMIS
static var InitObjectsLevel: 	Array<Array<Array<Int>>>	= [ 
[
	[13,1,1,	0],
	[9,3,1,		1],	
	[5,5,1,		2],
	[1,16,2,	3],
	[9,12,2,	3],
	[3,13,2,	3],
	[11,5,2,	3]
],
[
	[8,1,1,		0],
	[12,3,1,	1],
	[15,4,1,	2],
	[1,10,1,	0],
	[3,6,2,		3],
	[9,17,2,	3],
	[13,14,2,	3]
],
[
	[5,1,1,		0],
	[1,3,1,		1],
	[3,6,1,		2],
	[8,4,1,		3],
	[10,4,2,	4],
	[10,6,1,	5],
	[11,10,2,	6],
	[10,12,1,	7],
	[5,12,2,	8],
	[12,15,1,	9],
	[12,12,2,	10],
	[18,13,1,	11],
	[1,15,1,	12],
],
	
];

	// DEPLACEMENTS ENNEMIS

	static var Route : Array<Array<Array<Int>>>	=
	[ 
	[
		[DROITE,DROITE,DROITE,DROITE,DROITE,BAS,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,HAUT,LOOP],
		[DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,LOOP],
		[DROITE,DROITE,BAS,BAS,GAUCHE,GAUCHE,HAUT,HAUT,LOOP],
		[DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,LOOP],
	],
	[	
		[DROITE,DROITE,DROITE,DROITE,BAS,BAS,GAUCHE,GAUCHE,GAUCHE,GAUCHE,HAUT,HAUT,LOOP],
		[GAUCHE,GAUCHE,GAUCHE,GAUCHE,HAUT,HAUT,DROITE,DROITE,DROITE,DROITE,BAS,BAS,LOOP],
		[DROITE,DROITE,DROITE,BAS,BAS,GAUCHE,GAUCHE,GAUCHE,HAUT,HAUT,LOOP],
		[DROITE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,LOOP],
	],
	[	
		[DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,LOOP],
		[DROITE,DROITE,GAUCHE,GAUCHE,BAS,BAS,BAS,DROITE,DROITE,GAUCHE,GAUCHE,HAUT,HAUT,HAUT,LOOP],
		[GAUCHE,GAUCHE,BAS,BAS,BAS,DROITE,DROITE,GAUCHE,GAUCHE,HAUT,HAUT,HAUT,DROITE,DROITE,LOOP],
		[DROITE,DROITE,BAS,BAS,GAUCHE,GAUCHE,BAS,BAS,HAUT,HAUT,HAUT,HAUT,LOOP],
		[DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,LOOP],
		[DROITE,DROITE,DROITE,BAS,BAS,GAUCHE,GAUCHE,GAUCHE,HAUT,HAUT,LOOP],
		[DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,LOOP],
		[DROITE,DROITE,BAS,BAS,BAS,GAUCHE,GAUCHE,HAUT,HAUT,HAUT,LOOP],
		[DROITE,DROITE,DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,GAUCHE,LOOP],
		[GAUCHE,GAUCHE,HAUT,HAUT,HAUT,DROITE,DROITE,BAS,BAS,BAS,LOOP],
		[DROITE,DROITE,DROITE,GAUCHE,GAUCHE,GAUCHE,LOOP],
		[GAUCHE,BAS,BAS,BAS,DROITE,GAUCHE,HAUT,HAUT,HAUT,DROITE,LOOP],
		[DROITE,DROITE,BAS,BAS,HAUT,GAUCHE,GAUCHE,HAUT,LOOP],
	],
	];



										

//---------------------------------------------------------------------------------------------------		

   function new(inBitmap:BitmapData)
   {
      super();

		flash.Lib.current.addChild(this);
	  
		Splash 			= new Bitmap(new SPLASH_EMBED(0,0));
		Credits			= new Bitmap(new CREDIT_EMBED(0,0));

		var gdata 		= haxe.Resource.getBytes("audio-musique");
		music_game		= new flash.media.Sound();
		music_game.loadCompressedDataFromByteArray(gdata.getData(), gdata.length);


		var idata		= haxe.Resource.getBytes("audio-intro");
		music_intro		= new flash.media.Sound();
		music_intro.loadCompressedDataFromByteArray(idata.getData(), idata.length);

		var edata		= haxe.Resource.getBytes("audio-credits");
		music_credits	= new flash.media.Sound();
		music_credits.loadCompressedDataFromByteArray(edata.getData(), edata.length);
		
		var bdata		= haxe.Resource.getBytes("audio-bruit_1");
		bruit_1			= new flash.media.Sound();
		bruit_1.loadCompressedDataFromByteArray(bdata.getData(), bdata.length);

		var cdata		= haxe.Resource.getBytes("audio-select");
		bruit_select	= new flash.media.Sound();
		bruit_select.loadCompressedDataFromByteArray(cdata.getData(), cdata.length);

		var hdata		= haxe.Resource.getBytes("audio-hit");
		bruit_hit		= new flash.media.Sound();
		bruit_hit.loadCompressedDataFromByteArray(hdata.getData(), hdata.length);

		var ndata		= haxe.Resource.getBytes("audio-next");
		bruit_next		= new flash.media.Sound();
		bruit_next.loadCompressedDataFromByteArray(ndata.getData(), ndata.length);

		DrawView		= new BitmapData(Res_Width,Res_Height);
		addChild(new Bitmap(DrawView) );

		Graphics		= new _Draw(DrawView,inBitmap);

		stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown );
		stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp );
		stage.addEventListener(Event.ENTER_FRAME, OnEnter);

		HudText								= new TextField();
		HudText.x							= 20;
		HudText.y							= 0;
		var format:TextFormat				= new TextFormat();
		format.font							= "Arial";
		format.bold							= true;
		format.color						= 0xffffff;
		format.size							= 10;
		HudText.defaultTextFormat 			= format;
		HudText.text						= "";
		HudText.width						= Res_Width;
		HudText.filters						= [ new  GlowFilter(0x00000f, 1.0, 3, 3, 3, 3, false, false) ];
		HudText.alpha						= 0.5;


		MenuPlayText						= new TextField();
		MenuPlayText.x						= 16;
		MenuPlayText.y						= 132;
		var format:TextFormat				= new TextFormat();
		format.font							= "Arial";
		format.bold							= true;
		format.color						= 0x000000;
		format.size							= 11;
		MenuPlayText.defaultTextFormat		= format;
		MenuPlayText.text					= "PLAY";
		MenuPlayText.filters				= [ new  GlowFilter(0xffffff, 1.0, 3, 3, 3, 3, false, false) ];
		MenuPlayText.alpha					= 0.8;			

		MenuCreditsText						= new TextField();
		MenuCreditsText.x					= 16;
		MenuCreditsText.y					= 132+14;
		var format:TextFormat				= new TextFormat();
		format.font							= "Arial";
		format.bold							= true;
		format.color						= 0x000000;
		format.size							= 11;
		MenuCreditsText.defaultTextFormat	= format;
		MenuCreditsText.text				= "CREDITS";
		MenuCreditsText.filters				= [ new  GlowFilter(0xffffff, 1.0, 3, 3, 3, 3, false, false) ];
		MenuCreditsText.alpha				= 0.8;	
		

		NextLevelText						= new TextField();
		NextLevelText.x						= 0;
		NextLevelText.y						= 0;
		var format:TextFormat				= new TextFormat();
		format.font							= "Arial";
		format.bold							= true;
		format.color						= 0xE0C000;
		format.size							= 20;
		NextLevelText.defaultTextFormat		= format;
		NextLevelText.text					= "NEXT LEVEL";
		NextLevelText.filters				= [ new  GlowFilter(0xffffff, 1.0, 3, 3, 3, 3, false, false) ];
		NextLevelText.alpha					= 1.0;
		NextLevelText.width					= Res_Width;	
		
		
		ResetAll();
		ResetIntro();
	
		KeyDown	= [];

		GameState	= State.Intro;
}


//---------------------------------------------------------------------------------------------------		
	function ResetAll()
	{
		GameLevel	= 0;
	}
//---------------------------------------------------------------------------------------------------		
	function ResetIntro()
	{
		addChild(Splash);
		Splash.x	= 0;
		Splash.y	= 0;

		addChild(MenuPlayText);
		addChild(MenuCreditsText);
		MenuSelect	= 0;
		angle		= 0;	
		music_intro.play(0,1);
	}
//---------------------------------------------------------------------------------------------------		
	function ResetCredits()
	{
		addChild(Credits);
		Credits.x	= 0;
		Credits.y	= 0;
		music_credits.play(0,1);
	}

//---------------------------------------------------------------------------------------------------		
	function ResetGameLevel()
	{
		InitLeveMap (GameLevel);
		LevelAnim		= new Array();
		InitLevelAnim(0,6,3,[6,7,7,6]);
		InitLevelAnim(1,7,3,[7,6]);
		LevelObjects	= new Array();
		InitObjects(GameLevel);

		heroX			= 3*16;
		heroY			= 1*16;
		shiftX			= 0;
		shiftY			= 0;
		scrollX			= 0;
		scrollY			= 0;
		dirhero			= 1;
		old_dirhero		= 1;
		HudText.text	= ""+NbItem;
		ScaleText		= 1.0;
		heroFlash		= 30;
		heroDead		= false;
		heroWin			= false;
	}
	
	
//---------------------------------------------------------------------------------------------------		
	function ResetNextLevel()
	{
		NextLevelTick	= 60;
		NextLevelX 		= 60;
		NextLevelY 		= Res_Height;
		NextLevelDepY	= -64;
		addChild(NextLevelText);
		NextLevelText.x = NextLevelX;
		NextLevelText.y = NextLevelY;

	}
	
//---------------------------------------------------------------------------------------------------		
	function OnKeyDown(event:KeyboardEvent)
	{
		if (!KeyDown[event.keyCode])
		{
			KeyDown[event.keyCode] = true;
		}
	}
   
//---------------------------------------------------------------------------------------------------		
	function OnKeyUp(event:KeyboardEvent)
	{
		KeyDown[event.keyCode] = false;
	}

//---------------------------------------------------------------------------------------------------		
	function OnEnter(e:flash.events.Event)
	{
		Update();
		DrawView.lock();
		Render();
		DrawView.unlock();
	}
	
//---------------------------------------------------------------------------------------------------		
	function Update()
	{
	
		tanim++;
		if (tanim > 1)
		{
			tanim	= 0;
			anim++;
			anim	%= 3;
		}	
	
	
        if (GameState == State.Intro)
		{
			UpdateStateIntro();
		}
		else
        if (GameState == State.Credits)
		{
			UpdateStateCredits();
		}
		else
        if (GameState == State.Play)
		{
			UpdateStatePlay();
		}
		
	}
	
//---------------------------------------------------------------------------------------------------		
   function Render()
   {
        if (GameState == State.Intro)
		{
			RenderStateIntro();
		}
		else
        if (GameState == State.Credits)
		{
			RenderStateCredits();
		}
		else
        if (GameState == State.Play)
		{
			RenderStatePlay();
		}

   }
	
var angle: Float =0;

//---------------------------------------------------------------------------------------------------		
	function UpdateStateIntro()
	{
		if (KeyDown[ Keyboard.ENTER ])
		{

			if (MenuSelect == 0) 
			{
				removeChild(Splash);

				SoundMixer.stopAll();
				bruit_select.play();
				music_game.play(0,9999);

				ResetGameLevel();
				removeChild(MenuPlayText);
				removeChild(MenuCreditsText);
				addChild(HudText);
				GameState = State.Play;
			}
			else
			{
				removeChild(Splash);
				SoundMixer.stopAll();
				bruit_select.play();
				removeChild(MenuPlayText);
				removeChild(MenuCreditsText);
				ResetCredits();
				GameState = State.Credits;
				KeyDown[ Keyboard.ENTER ] = false;
			}
		}

		
		
		if (KeyDown[ Keyboard.UP ])		if (MenuSelect == 1)	{MenuSelect = 0;	bruit_select.play();}
		if (KeyDown[ Keyboard.DOWN ])	if (MenuSelect == 0)	{MenuSelect = 1;	bruit_select.play();}
		
		var sin	= Math.sin(angle)*0.5;
		var cos	= Math.cos(angle)*0.5;
		if (MenuSelect == 0)
		{
			MenuPlayText.scaleX		= 1+cos;
			MenuCreditsText.scaleX	= 1;
		}
		else
		{	
			MenuCreditsText.scaleX	= 1+cos;
			MenuPlayText.scaleX 	= 1;
		}
		angle+=0.6;
	}


//---------------------------------------------------------------------------------------------------		
	function UpdateStateCredits()
	{
		if (KeyDown[ Keyboard.ENTER ])
		{
			SoundMixer.stopAll();
			removeChild(Credits);
			ResetIntro();
			GameState = State.Intro;
			KeyDown[ Keyboard.ENTER ] = false;
		}
	}
	
//---------------------------------------------------------------------------------------------------		
	function UpdateStatePlay()
	{
		if ((shiftX==0) && (shiftY==0))
		{
			if (KeyDown[ Keyboard.LEFT ])	{shiftX -= 4;	dirhero = 3;}
			else
			if (KeyDown[ Keyboard.RIGHT])	{shiftX = 4;	dirhero = 1;}
			else
			if (KeyDown[ Keyboard.UP ])	{shiftY -= 4;	dirhero = 0;}
			else
			if (KeyDown[ Keyboard.DOWN])	{shiftY = 4;	dirhero = 2;}
		}

		TickLevelAnim();
		TickHero();
		TickObjects();
		TickScrolling();
		ColidHero();
		TickNextLevel();
		
		if (ScaleText >1.0) 
			ScaleText -= ScaleText*0.10;
		else
			ScaleText	= 1.0;
		HudText.scaleX = ScaleText;
		HudText.scaleY = ScaleText;			
		
		
	}
   
//---------------------------------------------------------------------------------------------------		
	function RenderStateIntro ()
	{
//		DrawView.fillRect(new Rectangle(0,0,Res_Width,Res_Height),0xE0E0FF);
	}
//---------------------------------------------------------------------------------------------------
	function RenderStateCredits ()
	{
	}
//---------------------------------------------------------------------------------------------------		
	function RenderStatePlay ()
	{
		DrawBackMap();
		DrawMap();
		DrawExplo();
		DrawObjects();
		DrawHero();
		DrawBanner();

	}

//---------------------------------------------------------------------------------------------------		
	function DrawBanner()
	{
		Graphics.draw(7,0,0);
	}
//---------------------------------------------------------------------------------------------------		
	function DrawMap()
	{
		for (y in 0 ... MAPSIZEY)
		{
			for ( x in 0 ... MAPSIZEX)
			{
				var tile	= LevelMap[y][x];
				if (tile<0)	tile = GetAnim (-tile);
				Graphics.draw(tile,(x*BLOCKSIZEX)-scrollX,(y*BLOCKSIZEY)-scrollY);
			}
		}
	}
//---------------------------------------------------------------------------------------------------		
	function DrawBackMap()
	{
		for (y in 0 ... MAPSIZEY)
		{
			for ( x in 0 ... MAPSIZEX)
			{
				Graphics.draw(5,(x*BLOCKSIZEX)-(scrollX/2),(y*BLOCKSIZEY)-(scrollY/2));
			}
		}
	}

//---------------------------------------------------------------------------------------------------		
	function GetAnim (id:Int) : Int
	{
		if (LevelAnim==null) return id;
		var len = LevelAnim.length;
		for (i in 0 ... Std.int(len))
		{
			if (id == LevelAnim[i][ANIM_INDEX])
				return (LevelAnim[i][ANIM_ID]);
		}
		return id;
	}

   

   
//---------------------------------------------------------------------------------------------------		
   static public function main()
   {
      var loader = new flash.display.Loader();
      loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,
          function(_) { new Game(untyped loader.content.bitmapData); });
      loader.load(new flash.net.URLRequest("tiles.png"));
   }

//---------------------------------------------------------------------------------------------------		
	function InitLeveMap (level : Int)
	{
		NbItem = 0;
		LevelMap = new Array();
		for (y in 0 ... MAPSIZEY)
		{
			for ( x in 0 ... MAPSIZEX)
			{
				if (LevelMap[y]== null)	LevelMap[y] = new Array();
				var tile	= InitMap[level][y][x];
				LevelMap[y][x] = tile;
				if (tile == 6 || tile == 7) 
				{
					NbItem++;
				}
				

			}
		}
	}

//---------------------------------------------------------------------------------------------------		
	function GetCellMap (x:Int,y:Int) : Int
	{
		if (LevelMap[y]== null) return(0);
		if (x <0 && x >19 && y < 0 && y > 19)	return(0);
		var cell = LevelMap[y][x];
		return cell<0 ? -cell : cell;
	}
//---------------------------------------------------------------------------------------------------		
	function SetCellMap (x:Int, y:Int, cell:Int)
	{
		LevelMap[y][x] = cell;
	}

//---------------------------------------------------------------------------------------------------		
	function InitLevelAnim (offset:Int, id:Int,delay:Int,list:Array<Int>)
	{
		if (LevelAnim[offset]== null)	LevelAnim[offset] = new Array();
		LevelAnim[offset][ANIM_INDEX]	= id;
		LevelAnim[offset][ANIM_ID]		= id;
		LevelAnim[offset][ANIM_DELAY]	= delay;
		LevelAnim[offset][ANIM_FRAME]	= 0;
		LevelAnim[offset][ANIM_AFRAME]	= 0;

		var len	= list.length;
		for (i in 0...Std.int(len))
			LevelAnim[offset][ANIM_ASIZE+i]	= list[i];

		// REMAP ALL ANIMATION IN MAP
		for (y in 0...MAPSIZEY)
		{
			for (x in 0...MAPSIZEX)
			{
				if (LevelMap[y][x] == id) 
				{
					LevelMap[y][x] = -LevelMap[y][x];
				}
			}
		}			
		
	}
//---------------------------------------------------------------------------------------------------		
	function TickLevelAnim ()
	{
		var len = LevelAnim.length;
		for (i in 0 ... Std.int(len))
		{
			var frame	= LevelAnim[i][ANIM_FRAME];
			var aframe	= LevelAnim[i][ANIM_AFRAME];
			var delay	= LevelAnim[i][ANIM_DELAY];
			var lenb	= LevelAnim[i].length-ANIM_ASIZE;
			var id		= LevelAnim[i][ANIM_ASIZE+aframe];
			frame++;
			if (frame>=delay)
			{
				frame	= 0;
				aframe++;
				aframe %= LevelAnim[i].length-ANIM_ASIZE;
				id	= LevelAnim[i][ANIM_ASIZE+aframe];
			}
			LevelAnim[i][ANIM_FRAME]	= frame;
			LevelAnim[i][ANIM_AFRAME]	= aframe;
			LevelAnim[i][ANIM_ID]		= id;
		}
	}

//---------------------------------------------------------------------------------------------------		
function TickScrolling ()
{
	if (heroDead)	return;

	var phx		= heroX;
	var phy		= heroY;
	var diffx	= ((phx-scrollX)-(Res_Width>>1));
	var diffy	= ((phy-scrollY)-(Res_Height>>1));
	scrollX		+=(diffx>>2);
	scrollY		+=(diffy>>2);

	if (scrollX < 0)					scrollX = 0;
	else
	if (scrollX > ((20*16)-Res_Width))	scrollX =(20*16)-Res_Width;
	if (scrollY < 0)					scrollY = 0;
	else
	if (scrollY > ((20*16)-Res_Height))	scrollY =(20*16)-Res_Height;
}

//---------------------------------------------------------------------------------------------------		
	function TickNextLevel ()
	{
		if (heroWin)
		{
			NextLevelDepY -= NextLevelDepY*0.30;
			NextLevelY += Std.int(NextLevelDepY);
			NextLevelText.y = NextLevelY;
			NextLevelTick--;
			if (NextLevelTick <=0)
			{
				GameLevel++;
				removeChild(NextLevelText);
				if (GameLevel >=3)
				{
					SoundMixer.stopAll();
					removeChild(HudText);
					ResetCredits();
					ResetAll();
					GameState = State.Credits;
					KeyDown[ Keyboard.ENTER ] = false;
				}
				else
				{
					SoundMixer.stopAll();
					music_game.play(0,9999);
					ResetGameLevel();
				}
			}
			
		
		}
		
	}
	
//---------------------------------------------------------------------------------------------------		
	function InitObjects (level : Int)
	{
		TotalObjects = 0;
		var len = InitObjectsLevel[level].length;
		for (i in 0 ...Std.int(len))
		{
			if (LevelObjects[i]== null)	LevelObjects[i] = new Array();
			LevelObjects[i][OBJ_FLAG]	= 1;
			LevelObjects[i][OBJ_POSX]	= InitObjectsLevel[level][i][0]*16;
			LevelObjects[i][OBJ_POSY]	= InitObjectsLevel[level][i][1]*16;
			LevelObjects[i][OBJ_TYPE]	= InitObjectsLevel[level][i][2];
			LevelObjects[i][OBJ_INDEX]	= InitObjectsLevel[level][i][3];
			LevelObjects[i][OBJ_SHIFTX]	= 0;
			LevelObjects[i][OBJ_SHIFTY]	= 0;
			LevelObjects[i][OBJ_TEMPO]	= 0;
			LevelObjects[i][OBJ_CPT]	= 0;
			LevelObjects[i][OBJ_DIR]	= 2;
			TotalObjects++;	
		}
	}

//---------------------------------------------------------------------------------------------------		
function TickObjects ()
{
	var dir;
	var len = LevelObjects.length;
	for (i in 0 ...Std.int(len))
	{
		if ((LevelObjects[i][OBJ_SHIFTX]==0) && (LevelObjects[i][OBJ_SHIFTY]==0))
		{
			dir = Route[GameLevel][LevelObjects[i][OBJ_INDEX]][LevelObjects[i][OBJ_CPT]];
			if (dir ==0) 
			{
				LevelObjects[i][OBJ_CPT]=0;
				dir = Route[GameLevel][LevelObjects[i][OBJ_INDEX]][0];
			}
			switch (dir)
			{
				case 1:		LevelObjects[i][OBJ_SHIFTX] = 16;
				case 2:		LevelObjects[i][OBJ_SHIFTY] = 16;
				case 3:		LevelObjects[i][OBJ_SHIFTX] = -16;
				case 4:		LevelObjects[i][OBJ_SHIFTY] = -16;
			}
			LevelObjects[i][OBJ_CPT]++;
		}
		else
		{
			if (LevelObjects[i][OBJ_SHIFTX]<0) {LevelObjects[i][OBJ_POSX]--;LevelObjects[i][OBJ_SHIFTX]++;LevelObjects[i][OBJ_DIR]=3;}
			else
			if (LevelObjects[i][OBJ_SHIFTX]>0) {LevelObjects[i][OBJ_POSX]++;LevelObjects[i][OBJ_SHIFTX]--;LevelObjects[i][OBJ_DIR]=1;}
			else
			if (LevelObjects[i][OBJ_SHIFTY]<0) {LevelObjects[i][OBJ_POSY]--;LevelObjects[i][OBJ_SHIFTY]++;LevelObjects[i][OBJ_DIR]=0;}
			else
			if (LevelObjects[i][OBJ_SHIFTY]>0) {LevelObjects[i][OBJ_POSY]++;LevelObjects[i][OBJ_SHIFTY]--;LevelObjects[i][OBJ_DIR]=2;}		
		}
	}
}


//---------------------------------------------------------------------------------------------------		
function DrawObjects ()
{
	var len = LevelObjects.length;
	for (i in 0 ...Std.int(len))
	{
		var sx		= (LevelObjects[i][OBJ_POSX]-scrollX);
		var sy		= (LevelObjects[i][OBJ_POSY]-scrollY);
		var frame	= e_hero_h;		// DEFAULT...!
		switch (LevelObjects[i][OBJ_TYPE])
		{
			case 1:
				sx	-= 2;
				sy	-= 14;
				if (LevelObjects[i][OBJ_DIR]==0) frame = e_hero_h;
				else
				if (LevelObjects[i][OBJ_DIR]==1) frame = e_hero_d;
				else
				if (LevelObjects[i][OBJ_DIR]==2) frame = e_hero_b;
				else
				if (LevelObjects[i][OBJ_DIR]==3) frame = e_hero_g;
			case 2:
				sx	-= 2;
				sy	-= 9;
				if (LevelObjects[i][OBJ_DIR]==1) frame = es_hero_d;
				else
				if (LevelObjects[i][OBJ_DIR]==3) frame = es_hero_g;
		}
		Graphics.draw(frame[anim],sx,sy);
	}

}
	


//---------------------------------------------------------------------------------------------------		
function TickHero ()
{
	if (heroWin)
	{
		return;
	}
	else
	if (heroDead)
	{
		heroDeadGravity += 2;
		heroY+=Std.int(heroDeadGravity);

		if ((heroY-scrollY)>Res_Height) {
			SoundMixer.stopAll();
			removeChild(HudText);
			ResetAll();
			ResetIntro();
			GameState = State.Intro;
		}
		return;
	}
	
	var hx: Int = (heroX>>4);
	var hy: Int = (heroY>>4);

	if ( (shiftX<0) && ( (colG==1)||(col==3)||(col==8) ) )  { shiftX=0; dirhero = old_dirhero; }
	else
	if ( (shiftX>0) && ( (colD==1)||(col==3)||(col==8) ) )  { shiftX=0; dirhero = old_dirhero; }
	else
	if ( (shiftY<0) && ( (colH==1)||(colH==2)||(col==2) ) ) { shiftY=0; dirhero = old_dirhero; }
	else
	if ( (shiftY>0) && ( (colB==1)||(colB==2)||(col==2) ) ) { shiftY=0; dirhero = old_dirhero; }
	
	if (shiftX<0) {heroX-=4; shiftX++;}
	else
	if (shiftX>0) {heroX+=4; shiftX--;}
	else
	if (shiftY<0) {heroY-=4; shiftY++;}
	else
	if (shiftY>0) {heroY+=4; shiftY--;}
	
	if ((shiftX==0) && (shiftY==0))
	{
		hx			= (heroX>>4);
		hy			= (heroY>>4);
		col  		= GetCellMap (hx,hy);
		colH 		= GetCellMap (hx,hy-1);
		colB 		= GetCellMap (hx,hy+1);
		colG 		= GetCellMap (hx-1,hy);
		colD 		= GetCellMap (hx+1,hy);
		if ( (col==6) || (col==7) )
		{
			bruit_1.play();
			SetCellMap(hx,hy,8);
			MakeExplo( hx,hy );
			if (NbItem>0)	NbItem--;
			if (NbItem == 0)
			{
				heroWin = true;
				ResetNextLevel();
				bruit_next.play();

			}
			HudText.text	= ""+NbItem;
			ScaleText		= 1.5;
		}
	}
}

//---------------------------------------------------------------------------------------------------		
function ColidHero()
{
	if (heroDead || heroWin)	return;

	var hx = heroX + 4;
	var hy = heroY + 4;
	var len = LevelObjects.length;
	for (i in 0 ...Std.int(len))
	{
		var sx = LevelObjects[i][OBJ_POSX];
		var sy = LevelObjects[i][OBJ_POSY];
		if ( (hx<sx+12) && (hx+12>sx+4) && (hy<sy+12) && (hy+12>sy+4) ) 
		{
			heroDead 		= true;
			heroDeadGravity = -10;
			heroFlash		= 0;
			bruit_hit.play();

		}
	}

}




//---------------------------------------------------------------------------------------------------		
function MakeExplo( x:Int ,y:Int)
{
	if (!explo_flag)
	{
		explo_x		= x*16;
		explo_y		= y*16;
		explo_tempo	= 0;
		explo_frame	= 0;
		explo_flag	= true;
	}
}

//---------------------------------------------------------------------------------------------------		
function DrawExplo()
{
	if (explo_flag)
	{
		Graphics.draw(e_explo[explo_frame],explo_x-scrollX,explo_y-scrollY);
		explo_frame++;
		if (explo_frame>=e_explo.length)	explo_flag = false;	
	}
}

//---------------------------------------------------------------------------------------------------
	function DrawHero()
	{
		var hframe	= g_hero_h;
		var hx		= (heroX-scrollX);
		var hy		= (heroY-scrollY)-9;
		var frame	= anim;
		if ((shiftX==0) && (shiftY==0))	frame = 2;				// STANDBY ANIMATION

		switch (dirhero)
		{
			case 0:		hframe	= g_hero_h;
			case 1:		hframe	= g_hero_d;
			case 2:		hframe	= g_hero_b;
			case 3:		hframe	= g_hero_g;
		}
		if (heroDead)	{hframe	= g_hero_h; frame = 0;}
		if (heroWin)	{frame = 0;}

		if (heroFlash & 3 == 0 ) Graphics.draw(hframe[frame],hx,hy);
		old_dirhero	= dirhero;
		if (heroFlash > 0) heroFlash--;
	}

	
//---------------------------------------------------------------------------------------------------


}



//---------------------------------------------------------------------------------------------------
class _Draw
{

static var coord : Array<Int> =[	


20,	96,	16,	16,
20,	112,16,	16,
20,	128,16,	16,
20,	144,16,	16,
20,	160,16,	16,
20,	176,16,	16,
20,	192,16,	16,
20,	208,16,	16,
20,	224,16,	16,
20,	240,16,	16,
20,	256,16,	16,
20,	272,16,	16,
20,	288,16,	16,
20,	304,16,	16,
20,	320,16,	16,
20,	336,16,	16,
20, 352,16,	16,
0,	360,16,	16,
20,	0,	16,	16,
20,	16,	16,	16,
20,	32,	16,	16,
20,	48,	16,	16,
20,	64,	16,	16,
20,	80,	16,	16,
0,	0,	20,	22,
0,	22,	20,	22,
0,	44,	20,	22,
0,	66,	20,	22,
0,	88,	20,	22,
0,	110,20,	22,
0,	132,20,	22,
0,	154,20,	22,
0,	176,20,	22,
0,	198,20,	22,
0,	220,20,	22,
0,	242,20,	22,
0,	264,20,	16,
0,	280,20,	16,
0,	296,20,	16,
0,	312,20,	16,
0,	328,20,	16,
0,	344,20,	16

];

	var spArena:		BitmapData;
	var spBits:			BitmapData;
	public function new(inArena:BitmapData,inBits:BitmapData)
	{
		spArena	= inArena;
		spBits	= inBits;
	}
	public function draw(frame:Int, posX:Float, posY:Float) {
		var ptframe: 	Int 		= (frame-1)*4;
		var spPoint:	Point		= new Point(posX,posY);
		var spRect:		Rectangle	= new Rectangle(coord[ptframe++],coord[ptframe++],coord[ptframe++],coord[ptframe]);
		spArena.copyPixels(spBits,spRect,spPoint,null,null,true);
	}

}

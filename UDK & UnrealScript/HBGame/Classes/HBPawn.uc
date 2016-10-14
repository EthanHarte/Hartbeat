/*
    TODO: Somehow remove the exec's from this file,
    and use states in HBPlayerController to control these functions.
*/

class HBPawn extends UTPawn;

//Adds Flashlight
var HBWeaponFlashlight Flashlight;
var bool HBbSneakOn;

///EXEC FUNCTIONS:
//Sprint function (mapped to the LEFT SHIFT)
exec function HBStartSprint()
{
	ConsoleCommand("Sprint");
    StopFiring();

	//ClientMessage("--Sprinting--");
    //ClientMessage("Pawnspeed before change is: " @ GroundSpeed);
	GroundSpeed = 320.0;
	//ClientMessage("Pawnspeed after change is: " @ GroundSpeed);
	//ClientMessage("--Sprinting--");
}

//Walk function (mapped to LEFT ALT)
exec function HBStartSneak()
{
	ConsoleCommand("Sneak");

    //ClientMessage("--Sneaking--");
    //ClientMessage("Pawnspeed before change is: " @ GroundSpeed);
	GroundSpeed = 130.0; //130 for crouching
	//ClientMessage("Pawnspeed after change is: " @ GroundSpeed);
	//ClientMessage("--Sneaking--");
    HBbSneakOn = true;
}

//Revert back to normal speed
exec function HBStopSprintOrSneak()
{
    
	//ClientMessage("--Normal--");
	//ClientMessage("Pawnspeed before change is: " @ GroundSpeed);
	GroundSpeed = 220.0;
	//ClientMessage("Pawnspeed after change is: " @ GroundSpeed);
    //ClientMessage("--Normal--");
    HBbSneakOn = false;
}

exec function HBToggleFlashlight()
{
	if(!Flashlight.LightComponent.bEnabled)
	{
		Flashlight.LightComponent.SetEnabled(true);
	}
	else
	{
		Flashlight.LightComponent.SetEnabled(false);
	}
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	//spawns flashlight from Pawn's location
	
	Flashlight = Spawn(class'HBWeaponFlashlight', self);
	
	Flashlight.SetBase(self);
	
	Flashlight.LightComponent.SetEnabled(false);
	
	//Able to change Brightness % of Flashlight
	
	Flashlight.LightComponent.SetLightProperties(1.00);
}

event UpdateEyeHeight( float DeltaTime )
{
	Super.UpdateEyeHeight(DeltaTime);
	
	//Allows Flashlight to move along with Pawn
	
	Flashlight.SetRotation(Controller.Rotation);
	
	//Adjusted so that Flashlight appears to come from Pawn helmet
	
	Flashlight.SetRelativeLocation(Controller.RelativeLocation + vect(20, 0, 25));
}

//Mutes footstep sound when walking/sneaking
//Calls function back in UTPawn
simulated function ActuallyPlayFootstepSound(int FootDown)
 {
 	local SoundCue FootSound;
 
 	FootSound = SoundGroupClass.static.GetFootstepSound(FootDown, GetMaterialBelowFeet());
	if ((FootSound != None) && (HBbSneakOn==false))
 	{
 		PlaySound(FootSound, false, true,,, true);
 	}
 }

function AddDefaultInventory()
{
    //Add our weapon
    InvManager.CreateInventory(class'HBWeapon');
}


///DEFAULT PLAYER PROPERTIES:
defaultproperties
{
	WalkingPct=+0.7
	GroundSpeed=220.0
	AirSpeed=220.0
	DodgeSpeed=300.0
    
    HBbSneakOn = false
    
    InventoryManagerClass=class'HBInventoryManager'
}
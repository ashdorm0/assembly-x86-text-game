;****************************************************************
; Tower Survival Game
; Student Name: Thomas Radulescu
; Student ID: C00302068
; Date Created: 20/02/2025
;
; Description: A turn-based RPG where the player faces increasingly
;              stronger enemies
;
; Known Bugs: None currently
;****************************************************************

                ORG     $1000           ; Start of program

;----------------------------------------------------------------
; Main Program Entry & Initialization
;----------------------------------------------------------------
START:
                BSR     SHOW_WELCOME         ; Display welcome message
                BSR     CHANGE_CLASS_EVENT   ; Display choose class message
                 
INIT_GAME:
                MOVE.W  #100, HEALTH         ; Initial health
                MOVE.W  #2,   DAMAGE         ; Initial damage
                MOVE.W  #50,  MONEY          ; Starting money
                MOVE.W  #10,  ACTIONS        ; Daily actions
                MOVE.W  #3,   LIVES          ; Starting lives
                MOVE.W  #1,   DAY            ; Current day
                MOVE.W  #1,   FLOOR          ; Current floor
                MOVE.W  #1,   STRENGTH       ; Initial strength
                MOVE.W  #1,   INTELIGENCE
                MOVE.W  #0,   BRONZE_AXE     ; No Bronze Axe owned initially
                MOVE.W  #0,   IRON_SWORD     ; No Iron Sword owned initially
                MOVE.W  #0,   FIREBOLT       ; Firebolt skill not learned
                MOVE.W  #0,   LIGHTNING_RAY ; Lightning ray not learned
                MOVE.W  #0,   POWER_STRIKE   ; Power strike not learned
                MOVE.W  #0,   CONCUSIVE_BLOW ; Concussion blow not learned
                MOVE.W  #0,   FIRST_EVENT_FLAG ; First event not yet triggered

;----------------------------------------------------------------
; Main Game Loop
;----------------------------------------------------------------
MAIN_LOOP:
                BSR     DISPLAY_STATS   ; Show player stats
                BSR     SHOW_MAIN_MENU  ; Display daily options
                BSR     HANDLE_INPUT    ; Process player's choice
                BSR     CHECK_ACTIONS   ; Check remaining actions
                BRA     MAIN_LOOP       ; Loop back for the next day

;----------------------------------------------------------------
; Subroutine: SHOW_WELCOME
; Description: Displays the welcome message to the player.
;----------------------------------------------------------------
SHOW_WELCOME:
                MOVE    #11, D0
                MOVE    #$1408, D1
                TRAP    #15
                LEA     WELCOME_MSG_1, A1 ; Load address of welcome message
                MOVE    #14, D0        ; Set display parameter
                TRAP    #15            ; Display the message
                MOVE    #11, D0
                MOVE    #$1409, D1
                TRAP    #15
                LEA     WELCOME_MSG_2, A1 ; Load address of welcome message
                MOVE    #14, D0        ; Set display parameter
                TRAP    #15            ; Display the message
                MOVE    #11, D0
                MOVE    #$140A, D1
                TRAP    #15
                LEA     WELCOME_MSG_3, A1 ; Load address of welcome message
                MOVE    #14, D0        ; Set display parameter
                TRAP    #15            ; Display the message
                MOVE    #11, D0
                MOVE    #$140B, D1
                TRAP    #15
                LEA     WELCOME_MSG_4, A1 ; Load address of welcome message
                MOVE    #14, D0        ; Set display parameter
                TRAP    #15            ; Display the message
                MOVE    #11, D0
                MOVE    #$140C, D1
                TRAP    #15
                LEA     WELCOME_MSG_5, A1 ; Load address of welcome message
                MOVE    #14, D0        ; Set display parameter
                TRAP    #15            ; Display the message
                MOVE    #11, D0
                MOVE    #$140D, D1
                TRAP    #15
                LEA     WELCOME_MSG_6, A1 ; Load address of welcome message
                MOVE    #14, D0        ; Set display parameter
                TRAP    #15            ; Display the message
                BSR     CONTINUE
                RTS                    ; Return to caller

KEEP_GOING:
                RTS
;----------------------------------------------------------------
; Subroutine: DISPLAY_STATS
; Description: Displays the player's statistics on the screen.
;----------------------------------------------------------------
DISPLAY_STATS:
                CLR.L   D1
                BSR     CLEAR_SCREEN
                LEA     BORDER, A1
                MOVE    #14, D0
                TRAP    #15
                
                BSR     NEXT_LINE
                
                LEA     FLOOR_MSG, A1
                MOVE.B  #14, D0
                TRAP    #15
                MOVE    FLOOR, D1
                MOVE    #3, D0
                TRAP    #15
                
                BSR     NEXT_LINE
                
                LEA     DAY_MSG, A1
                MOVE.B  #14, D0
                TRAP    #15
                MOVE    DAY, D1
                MOVE    #3, D0
                TRAP    #15
                BSR     NEXT_LINE
                LEA     BORDER, A1
                MOVE.B  #14, D0
                TRAP    #15
                
                BSR     NEXT_LINE
                
          
                MOVE.B  #14, D0
                TRAP    #15
                LEA     HEALTH_MSG, A1
                MOVE    #14, D0
                TRAP    #15
                MOVE    HEALTH, D1
                MOVE    #3, D0
                TRAP    #15
                
                BSR     NEXT_LINE
                
                LEA     DAMAGE_MSG, A1
                MOVE    #14, D0
                TRAP    #15
                MOVE    DAMAGE, D1
                MOVE    #3, D0
                TRAP    #15
                
                BSR     NEXT_LINE
                
                LEA     MONEY_MSG, A1
                MOVE    #14, D0
                TRAP    #15
                MOVE    MONEY, D1
                MOVE    #3, D0
                TRAP    #15
                
                BSR     NEXT_LINE
                
                LEA     ACTIONS_MSG, A1
                MOVE    #14, D0
                TRAP    #15
                MOVE    ACTIONS, D1
                MOVE    #3, D0
                TRAP    #15
                
                BSR     NEXT_LINE
                
                LEA     LIVES_MSG, A1
                MOVE    #14, D0
                TRAP    #15
                MOVE    LIVES, D1
                MOVE    #3, D0
                TRAP    #15
                
                BSR     NEXT_LINE
 
                CMP     #1, MAGE_BOOL
                BEQ     ADD_MANA_STAT
                CMP     #1, WARRIOR_BOOL
                BEQ     ADD_DR_STAT
                RTS

;;----------------------------------------------------------------
; Subroutine: CHANGE_CLASS_EVENT
; Description: Handles the special event when the player first reaches day 3.
;----------------------------------------------------------------
CHANGE_CLASS_EVENT:
                MOVE    #1, FIRST_EVENT_FLAG ; Set the event flag so it doesn't repeat
                BSR     CLEAR_SCREEN        ; Clear the screen before displaying the event message
                LEA     FIRST_EVENT_MSG, A1 ; Load the address of the first event message into A1
                MOVE    #14, D0             ; 
                TRAP    #15                 ; Call system interrupt to display the message
                BSR     EVENT_INPUT         ; Call the input handler for event choices
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: EVENT_INPUT
; Description: Processes input during the first event.
;----------------------------------------------------------------
EVENT_INPUT:
                BSR     CONTINUE            ; Wait for player confirmation 
                CMP     #1, D1              ; Compare input with 1 (Mage choice)
                BEQ     SET_MAGE_TRUE       ; If player selects 1, set Mage class
                CMP     #2, D1              ; Compare input with 2 (Warrior choice)
                BEQ     SET_WARRIOR_TRUE    ; If player selects 2, set Warrior class
                BRA     EVENT_INPUT         ; If input is invalid, reprompt for input
                RTS                         ; Return from subroutine 

;----------------------------------------------------------------
; Subroutine: SET_WARRIOR_TRUE
; Description: Activates the damage reduction bonus by setting the Warrior flag.
;----------------------------------------------------------------
SET_WARRIOR_TRUE:
                MOVE    #1, WARRIOR_BOOL    ; Set Warrior flag to indicate the choice
                LEA     WARRIOR_ACCEPT_MSG, A1 ; Load Warrior acceptance message into A1
                MOVE    #14, D0             ; Set message type (assumed to be 14)
                TRAP    #15                 ; Call system interrupt to display message
                BSR     CONTINUE            ; Wait for player confirmation
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: SET_MAGE_TRUE
; Description: Activates the mana bonus by setting the Mage flag.
;----------------------------------------------------------------
SET_MAGE_TRUE:
                MOVE    #1, MAGE_BOOL       ; Set Mage flag to indicate the choice
                LEA     MAGE_ACCEPT_MSG, A1 ; Load Mage acceptance message into A1
                MOVE    #14, D0             ; Set message type (assumed to be 14)
                TRAP    #15                 ; Call system interrupt to display message
                BSR     CONTINUE            ; Wait for player confirmation
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: INIT_ENEMY
; Description: Initializes enemy health and damage for combat.
;----------------------------------------------------------------
INIT_ENEMY:
                CLR.L   D1                  ; Clear register D1 (used for calculations)
                CLR.L   D2                  ; Clear register D2 (used for calculations)
                MOVE.W  #50, ENEMY_HEALTH   ; Set base enemy health to 50
                MOVE.W  #15, ENEMY_DAMAGE   ; Set base enemy damage to 15
                MOVE.W  FLOOR, D1           ; Load current floor level into D1
                MOVE.W  ENEMY_HEALTH, D2    ; Copy base enemy health into D2
                MOVE.W  ENEMY_DAMAGE, D3
                MULU    #2, D1              ; Multiply floor number by 2
                MULU    D1, D2              ; Multiply enemy health by floor-based factor
                ADD     D3, D3
                MULU    D1, D3
                MOVE.W  D3, ENEMY_DAMAGE    ; Update enemy damage
                MOVE.W  D2, ENEMY_HEALTH    ; Update enemy health with calculated value
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: START_COMBAT
; Description: Initiates combat by setting up enemy parameters.
;----------------------------------------------------------------
START_COMBAT:
                BSR     INIT_ENEMY          ; Call enemy initialization routine to set up health and damage
                
;----------------------------------------------------------------
; Subroutine: COMBAT_LOOP
; Description: Main loop for handling combat encounters.
;----------------------------------------------------------------
COMBAT_LOOP:                
                BSR     DISPLAY_COMBAT      ; Display current player and enemy status
                BSR     CHOOSE_OPTION       ; Prompt player with combat choices
                BSR     PROCESS_OPTION      ; Process player's selected action
                BRA     COMBAT_LOOP         ; Loop back to continue combat until resolved
                
;----------------------------------------------------------------
; Subroutine: ENEMY_TURN
; Description: Handles enemy's turn in combat.
;----------------------------------------------------------------
ENEMY_TURN:
                BSR     DISPLAY_COMBAT      ; Refresh the combat display
                BSR     ENEMY_ATTACK_ACTION ; Execute enemy attack sequence

;----------------------------------------------------------------
; Subroutine: PROCESS_OPTION
; Description: Reads and processes the player's combat choice.
;----------------------------------------------------------------
PROCESS_OPTION:
                MOVE    #4, D0              ; Set trap function for input reading
                TRAP    #15                 ; Call system interrupt for input
                CMP     #1, D1              ; If player selects option 1 (Basic Attack)
                BEQ     BASIC_ATTACK
                CMP     #2, D1              ; If player selects option 2 (Weapon Selection)
                BEQ     CHOOSE_WEAPON
                CMP     #3, D1              ; If player selects option 3 (Skill Selection)
                BEQ     CHOOSE_SKILL
                RTS                          ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: BASIC_ATTACK
; Description: Handles a basic attack by the player.
;----------------------------------------------------------------
BASIC_ATTACK:
                BSR     DISPLAY_COMBAT      ; Refresh combat display
                MOVE    DAMAGE, D1          ; Load player damage value into D1
                MOVE    ENEMY_HEALTH, D2    ; Load enemy health into D2
                SUB     D1, D2              ; Subtract damage from enemy health
                CMP     #0, D2              ; Check if enemy health is zero or below
                BLE     ENEMY_DEFEAT        ; If enemy is defeated, jump to enemy defeat routine
                MOVE    D2, ENEMY_HEALTH    ; Store updated enemy health value
                MOVE    D1, DAMAGE          ; Store damage dealt
                MOVE    #11, D0             
                MOVE    #$0005, D1
                TRAP    #15                 ; Display damage effect
                LEA     DAMAGE_DEALT_MSG, A1 ; Load address of damage message
                MOVE    #14, D0             
                TRAP    #15                 ; Display message
                MOVE    DAMAGE, D1          
                MOVE    #3, D0              
                TRAP    #15                 ; Output numerical damage value
                LEA     DAMAGE_LITERAL_MSG, A1 ; Load literal damage message
                MOVE    #14, D0             
                TRAP    #15                 ; Display literal damage text
                BSR     CONTINUE            ; Wait for player to acknowledge
                BRA     ENEMY_TURN          ; Proceed to enemy's turn

;----------------------------------------------------------------
; Subroutine: CHOOSE_WEAPON
; Description: Displays weapon selection screen and processes selection.
;----------------------------------------------------------------
CHOOSE_WEAPON:
                BSR     DISPLAY_WEAPONS     ; Display available weapons
                BSR     CONTINUE            ; Wait for player input
                CMP     #1, D1              ; Check if player selects first weapon
                BEQ     CHECK_WEAPON_1
                CMP     #2, D1              ; Check if player selects second weapon
                BEQ     CHECK_WEAPON_2
                RTS                          ; Return if invalid input

;----------------------------------------------------------------
; Subroutine: CHOOSE_SKILL
; Description: Checks if the player is a Mage or Warrior and handles skill selection accordingly.
;----------------------------------------------------------------
CHOOSE_SKILL:
                CMP     #1, MAGE_BOOL       ; Check if the player is a Mage
                BEQ     HANDLE_MAGE_SKILLS
                CMP     #1, WARRIOR_BOOL    ; Check if the player is a Warrior
                BEQ     HANDLE_WARRIOR_SKILLS
                RTS                          ; Return if no valid class is selected

;----------------------------------------------------------------
; Subroutine: HANDLE_MAGE_SKILLS
; Description: Displays Mage skill selection and processes input.
;----------------------------------------------------------------
HANDLE_MAGE_SKILLS:
                BSR     DISPLAY_MAGE_SKILLS ; Show available Mage skills
                BSR     CONTINUE            ; Wait for player input
                CMP     #1, D1              ; If first skill selected...
                BEQ     CHECK_SKILL_1
                CMP     #2, D1              ; If second skill selected...
                BEQ     CHECK_SKILL_2
                RTS                          ; Return if invalid input

;----------------------------------------------------------------
; Subroutine: HANDLE_WARRIOR_SKILLS
; Description: Displays Warrior skill selection and processes input.
;----------------------------------------------------------------
HANDLE_WARRIOR_SKILLS:
                BSR     DISPLAY_WARRIOR_SKILLS ; Show available Warrior skills
                BSR     CONTINUE               ; Wait for player input
                CMP     #1, D1                 ; If first skill selected...
                BEQ     CHECK_SKILL_1
                CMP     #2, D1                 ; If second skill selected...
                BEQ     CHECK_SKILL_2
                RTS                              ; Return if invalid input

;----------------------------------------------------------------
; Subroutine: CHECK_SKILL_1
; Description: Determines if the selected skill is a Mage or Warrior skill.
;----------------------------------------------------------------
CHECK_SKILL_1:
                CMP     #1, FIREBOLT        ; Check if Firebolt is unlocked
                BEQ     CHECK_MAGE_SKILL_1  
                BRA     CHECK_WARRIOR_SKILL_1 ; Otherwise, check Warrior skills

;----------------------------------------------------------------
; Subroutine: CHECK_SKILL_2
; Description: Determines if the selected skill is a Mage or Warrior skill.
;----------------------------------------------------------------
CHECK_SKILL_2:
                CMP     #1, LIGHTNING_RAY   ; Check if Lightning Ray is unlocked
                BEQ     CHECK_MAGE_SKILL_2
                BRA     CHECK_WARRIOR_SKILL_2 ; Otherwise, check Warrior skills

;----------------------------------------------------------------
; Subroutine: CHECK_MAGE_SKILL_1
; Description: Verifies if Firebolt skill is available, then executes it.
;----------------------------------------------------------------
CHECK_MAGE_SKILL_1:
                CMP     #1, FIREBOLT        ; Check if Firebolt is learned
                BNE     NO_SKILL            ; If not, display error message
                BRA     USE_FIREBOLT        ; Otherwise, execute Firebolt

;----------------------------------------------------------------
; Subroutine: CHECK_MAGE_SKILL_2
; Description: Verifies if Lightning Ray skill is available, then executes it.
;----------------------------------------------------------------
CHECK_MAGE_SKILL_2:
                CMP     #1, LIGHTNING_RAY    ; Check if Lightning Ray is learned
                BNE     NO_SKILL             ; If not, display error message
                BRA     USE_LIGHTNING_RAY    ; Otherwise, execute Lightning Ray
;----------------------------------------------------------------
; Subroutine: CHECK_WARRIOR_SKILL_1
; Description: Verifies if the "Power Strike" skill is available, then executes it.
;----------------------------------------------------------------
CHECK_WARRIOR_SKILL_1:
                CMP     #1, POWER_STRIKE      ; Check if Power Strike skill is unlocked
                BNE     NO_SKILL              ; If not, display error message
                BRA     USE_POWER_STRIKE      ; Otherwise, execute Power Strike

;----------------------------------------------------------------
; Subroutine: CHECK_WARRIOR_SKILL_2
; Description: Verifies if the "Concussive Blow" skill is available, then executes it.
;----------------------------------------------------------------
CHECK_WARRIOR_SKILL_2:
                CMP     #1, CONCUSIVE_BLOW    ; Check if Concussive Blow skill is unlocked
                BNE     NO_SKILL              ; If not, display error message
                BRA     USE_CONCUSIVE_BLOW    ; Otherwise, execute Concussive Blow

;----------------------------------------------------------------
; Subroutine: CHECK_WEAPON_1
; Description: Verifies if the player has the Bronze Axe equipped.
;----------------------------------------------------------------
CHECK_WEAPON_1:
                CMP     #1, BRONZE_AXE        ; Check if Bronze Axe is equipped
                BNE     NO_WEAPON_MSG         ; If not, show error message
                BRA     USE_BRONZE_AXE        ; Otherwise, use Bronze Axe

;----------------------------------------------------------------
; Subroutine: CHECK_WEAPON_2
; Description: Verifies if the player has the Iron Sword equipped.
;----------------------------------------------------------------
CHECK_WEAPON_2:
                CMP     #1, IRON_SWORD        ; Check if Iron Sword is equipped
                BNE     NO_WEAPON_MSG         ; If not, show error message
                BEQ     USE_IRON_SWORD        ; Otherwise, use Iron Sword

;----------------------------------------------------------------
; Subroutine: USE_BRONZE_AXE
; Description: Sets Bronze Axe damage and proceeds to weapon attack.
;----------------------------------------------------------------
USE_BRONZE_AXE:
                MOVE    BRONZE_AXE_DMG, D2    ; Load Bronze Axe damage value
                BRA     USE_WEAPON            ; Proceed to attack with weapon

;----------------------------------------------------------------
; Subroutine: USE_IRON_SWORD
; Description: Sets Iron Sword damage and proceeds to weapon attack.
;----------------------------------------------------------------
USE_IRON_SWORD:
                MOVE    IRON_SWORD_DMG, D2    ; Load Iron Sword damage value
                BRA     USE_WEAPON            ; Proceed to attack with weapon

;----------------------------------------------------------------
; Subroutine: USE_FIREBOLT
; Description: Executes Firebolt spell attack with damage and mana cost.
;----------------------------------------------------------------
USE_FIREBOLT:
                MOVE    FIREBOLT_DMG, D4      ; Load Firebolt damage value
                MOVE    #20, D6               ; Set Firebolt mana cost
                BRA     USE_MAGE_SKILL        ; Proceed to use Mage skill

;----------------------------------------------------------------
; Subroutine: USE_LIGHTNING_RAY
; Description: Executes Lightning Ray spell attack with damage and mana cost.
;----------------------------------------------------------------
USE_LIGHTNING_RAY:
                MOVE    LIGHTNING_RAY_DMG, D4 ; Load Lightning Ray damage value
                MOVE    #50, D6               ; Set Lightning Ray mana cost
                BRA     USE_MAGE_SKILL        ; Proceed to use Mage skill

;----------------------------------------------------------------
; Subroutine: USE_POWER_STRIKE
; Description: Executes Power Strike attack.
;----------------------------------------------------------------
USE_POWER_STRIKE:
                MOVE    POWER_STRIKE_DMG, D4  ; Load Power Strike damage value
                BRA     USE_WARRIOR_SKILL     ; Proceed to use Warrior skill

;----------------------------------------------------------------
; Subroutine: USE_CONCUSIVE_BLOW
; Description: Executes Concussive Blow attack.
;----------------------------------------------------------------
USE_CONCUSIVE_BLOW:
                MOVE    CONCUSIVE_BLOW_DMG, D4 ; Load Concussive Blow damage value
                BRA     USE_WARRIOR_SKILL      ; Proceed to use Warrior skill

;----------------------------------------------------------------
; Subroutine: NO_SKILL
; Description: Displays a message when the player selects an unavailable skill.
;----------------------------------------------------------------
NO_SKILL:
                LEA     NO_SKILL_MSG, A1      ; Load address of "No Skill Available" message
                MOVE    #14, D0
                TRAP    #15                   ; Display message
                BSR     CONTINUE              ; Wait for player to acknowledge
                BRA     COMBAT_LOOP           ; Return to combat loop

;----------------------------------------------------------------
; Subroutine: USE_WEAPON
; Description: Handles weapon-based attacks and applies damage to the enemy.
;----------------------------------------------------------------
USE_WEAPON:
                BSR     DISPLAY_COMBAT        ; Refresh combat display
                MOVE    DAMAGE, D1            ; Load base player damage
                MOVE    ENEMY_HEALTH, D3      ; Load enemy health
                ADD     D2, D1                ; Add weapon damage to player's attack
                SUB     D1, D3                ; Subtract damage from enemy health
                CMP     #0, D3                ; Check if enemy is defeated
                BLE     ENEMY_DEFEAT          ; If so, go to enemy defeat routine
                MOVE    D3, ENEMY_HEALTH      ; Store updated enemy health
                MOVE    D1, DAMAGE            ; Store new total damage dealt
                MOVE    #11, D0              
                MOVE    #$0005, D1
                TRAP    #15                   ; Display damage effect
                LEA     DAMAGE_DEALT_MSG, A1  ; Load damage message address
                MOVE    #14, D0              
                TRAP    #15                   ; Display damage message
                MOVE    DAMAGE, D1           
                MOVE    #3, D0               
                TRAP    #15                   ; Display damage value
                LEA     DAMAGE_LITERAL_MSG, A1 ; Load literal damage message
                MOVE    #14, D0              
                TRAP    #15                   ; Display literal message
                SUB     D2, D1                ; Reset damage value for next turn
                MOVE    D1, DAMAGE            ; Store updated damage value
                BSR     CONTINUE              ; Wait for player input before proceeding
                BRA     ENEMY_TURN            ; Proceed to enemy's turn
;----------------------------------------------------------------
; Subroutine: USE_MAGE_SKILL
; Description: Executes a magic attack using the player's intelligence stat.
;              Consumes mana and applies damage to the enemy.
;----------------------------------------------------------------
USE_MAGE_SKILL:
                BSR     DISPLAY_COMBAT        ; Refresh combat display
                MOVE    MANA, D1              ; Load current mana
                MOVE    INTELIGENCE, D2       ; Load intelligence stat
                MOVE    ENEMY_HEALTH, D3      ; Load enemy's current health
                MOVE    DAMAGE, D5            ; Backup player's base damage
                
                CMP     D6, D1                ; Check if player has enough mana
                BLT     NO_MANA               ; If not, show "No Mana" message
                
                SUB     D6, D1                ; Subtract mana cost
                MOVE    D1, MANA              ; Update player's mana
                
                ADD     D2, D4                ; Increase spell damage based on intelligence
                SUB     D4, D3                ; Apply damage to enemy
                CMP     #0, D3                ; Check if enemy is defeated
                BLE     ENEMY_DEFEAT          ; If so, handle enemy defeat
                
                MOVE    D3, ENEMY_HEALTH      ; Update enemy's health
                MOVE    D4, DAMAGE            ; Store total damage dealt
                
                MOVE    #11, D0               
                MOVE    #$0005, D1
                TRAP    #15                   ; Display damage effect
                LEA     DAMAGE_DEALT_MSG, A1  ; Load damage message
                MOVE    #14, D0
                TRAP    #15                   ; Display message
                MOVE    DAMAGE, D1
                MOVE    #3, D0
                TRAP    #15                   ; Display damage value
                LEA     DAMAGE_LITERAL_MSG, A1
                MOVE    #14, D0
                TRAP    #15                   ; Display damage description
                
                MOVE    D5, DAMAGE            ; Restore original player damage
                BSR     CONTINUE              ; Wait for player input
                BRA     ENEMY_TURN            ; Proceed to enemy's turn

;----------------------------------------------------------------
; Subroutine: USE_WARRIOR_SKILL
; Description: Executes a physical attack using the player's base damage.
;              Directly applies damage to the enemy.
;----------------------------------------------------------------
USE_WARRIOR_SKILL:
                BSR     DISPLAY_COMBAT        ; Refresh combat display
                MOVE    MANA, D1              ; Load current mana (not used here)
                MOVE    DAMAGE, D2            ; Load player's base damage
                MOVE    ENEMY_HEALTH, D3      ; Load enemy's current health
                
                ADD     D2, D4                ; Increase total attack damage
                SUB     D4, D3                ; Apply damage to enemy
                CMP     #0, D3                ; Check if enemy is defeated
                BLE     ENEMY_DEFEAT          ; If so, handle enemy defeat
                
                MOVE    D3, ENEMY_HEALTH      ; Update enemy's health
                MOVE    D4, DAMAGE            ; Store total damage dealt
                
                MOVE    #11, D0               
                MOVE    #$0005, D1
                TRAP    #15                   ; Display damage effect
                LEA     DAMAGE_DEALT_MSG, A1  ; Load damage message
                MOVE    #14, D0
                TRAP    #15                   ; Display message
                MOVE    DAMAGE, D1
                MOVE    #3, D0
                TRAP    #15                   ; Display damage value
                LEA     DAMAGE_LITERAL_MSG, A1
                MOVE    #14, D0
                TRAP    #15                   ; Display damage description
                
                MOVE    D2, DAMAGE            ; Restore original player damage
                BSR     CONTINUE              ; Wait for player input
                BRA     ENEMY_TURN            ; Proceed to enemy's turn

;----------------------------------------------------------------
; Subroutine: NO_MANA
; Description: Displays a message when the player attempts to use a skill 
;              but does not have enough mana.
;----------------------------------------------------------------
NO_MANA:
                MOVE    #11, D0               
                MOVE    #$0005, D1
                TRAP    #15                   ; Display error effect
                LEA     NO_MANA_MSG, A1       ; Load "Not enough mana" message
                MOVE    #14, D0
                TRAP    #15                   ; Display message
                BSR     CONTINUE              ; Wait for player input
                BRA     COMBAT_LOOP           ; Return to combat loop

;----------------------------------------------------------------
; Subroutine: NO_CLASS
; Description: Displays a message when the player tries to use a class-specific
;              ability but does not have the required class.
;----------------------------------------------------------------
NO_CLASS:
                LEA     NO_CLASS_MSG, A1      ; Load "No class ability available" message
                MOVE    #14, D0
                TRAP    #15                   ; Display message
                BSR     CONTINUE              ; Wait for player input
                BRA     COMBAT_LOOP           ; Return to combat loop

;----------------------------------------------------------------
; Subroutine: ENEMY_DEFEAT
; Description: Handles the enemy's defeat sequence.
;              Displays victory messages, progresses the game, 
;              and increases player stats.
;----------------------------------------------------------------
ENEMY_DEFEAT:
                BSR     CLEAR_SCREEN                ; Clear screen for victory message
                LEA     FIRST_ENEMY_DEFEAT_MSG, A1  ; Load message: "Enemy Defeated!"
                MOVE    #14, D0
                TRAP    #15                         ; Display message
                BSR     CONTINUE                    ; Wait for player input
                
                BSR     CLEAR_SCREEN                ; Clear screen again
                LEA     FIRST_FLOOR_CLEAR_MSG, A1   ; Load message: "Floor Cleared!"
                MOVE    #14, D0
                TRAP    #15                         ; Display message

                ADD     #1, FLOOR                   ; Advance to the next floor
                BSR     CONTINUE                    ; Wait for player input
                
                BSR     ADVANCE_DAY                 ; Increment in-game day counter
                BSR     STAT_INCREASE               ; Increase player stats
                
                BRA     MAIN_LOOP                   ; Return to main game loop

;----------------------------------------------------------------
; Subroutine: ENEMY_ATTACK_ACTION
; Description: Handles enemy attack sequence.
;              Calculates damage and checks if player is defeated.
;----------------------------------------------------------------
ENEMY_ATTACK_ACTION: 
                CLR.L   D1                          ; Clear D1 register (damage)
                CLR.L   D2                          ; Clear D2 register (health)
                
                MOVE    #11, D0
                MOVE    #$0005, D1
                TRAP    #15                         ; Display attack effect
                
                MOVE.W  ENEMY_DAMAGE, D1            ; Load enemy's attack damage
                MOVE.W  HEALTH, D2                  ; Load player's current health
                
                SUB     D1, D2                      ; Subtract damage from health
                CMP     #0, D2                      ; Check if player is dead
                BLE     PLAYER_DEFEAT               ; If health ? 0, trigger defeat
                
                MOVE    D2, HEALTH                  ; Update player's health
                
                LEA     ENEMY_DAMAGE_DEALT_MSG, A1  ; Load enemy attack message
                MOVE    #14, D0
                TRAP    #15                         ; Display message
                
                MOVE    #3, D0
                TRAP    #15                         ; Display damage amount
                
                LEA     DAMAGE_LITERAL_MSG, A1      ; Load "damage taken" message
                MOVE    #14, D0
                TRAP    #15                         ; Display message
                
                BSR     CONTINUE                    ; Wait for player input
                BRA     COMBAT_LOOP                 ; Return to combat loop

;----------------------------------------------------------------
; Subroutine: STAT_INCREASE
; Description: Increases player stats upon clearing a floor.
;              Checks player class and increases the appropriate stat.
;----------------------------------------------------------------
STAT_INCREASE:
                CMP     #1, MAGE_BOOL               ; Check if player is a Mage
                BEQ     INCREASE_INT                ; If so, increase intelligence
                
                CMP     #1, WARRIOR_BOOL            ; Check if player is a Warrior
                BEQ     INCREASE_STRENGTH           ; If so, increase strength
                
                BSR     CONTINUE                    ; Wait for player input
                RTS                                 ; Return from subroutine
INCREASE_INT:
                ; Increase Intelligence stat by 2
                MOVE    INTELIGENCE, D1  ; Load current intelligence value into D1
                ADD     #2, D1          ; Increase intelligence by 2
                MOVE    D1, INTELIGENCE  ; Store updated intelligence value back
                LEA     INT_INCREASE_MSG, A1  ; Load message for intelligence increase
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap to print message
                RTS                     ; Return from subroutine

INCREASE_STRENGTH:
                ; Increase Strength stat by 2
                MOVE    STRENGTH, D1    ; Load current strength value into D1
                ADD     #2, D1          ; Increase strength by 2
                MOVE    D1, STRENGTH    ; Store updated strength value back
                LEA     INT_INCREASE_MSG, A1  ; Load message for strength increase (Potential Bug: Should this be STR_INCREASE_MSG?)
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap to print message
                RTS                     ; Return from subroutine

PLAYER_DEFEAT:
                ; Handle player's defeat scenario
                BSR     CLEAR_SCREEN    ; Clear screen before displaying defeat message
                MOVE    #11, D0         ; Set TRAP function for clearing display area
                MOVE.W  #$AA, D1        ; Load special defeat code into D1
                TRAP    #15             ; Call system trap
                LEA     PLAYER_DEFEAT_MSG, A1  ; Load player defeat message
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap to print message
                SUB     #1, LIVES       ; Decrease player's life count by 1
                BSR     ADVANCE_DAY     ; Call subroutine to advance the game day
                CMP     #0, LIVES
                BLE     GAME_OVER
                BRA     MAIN_LOOP
                

;----------------------------------------------------------------
; Subroutine: CHOOSE_OPTION
; Description: Prompts the player to choose an action in combat.
;----------------------------------------------------------------
CHOOSE_OPTION:
                MOVE    #11, D0         ; Set TRAP function for clearing display area
                MOVE    #$0007, D1      ; Set display area identifier
                TRAP    #15             ; Call system trap
                LEA     CHOOSE_OPTION_MSG, A1 ; Load combat options message
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap to print message
                RTS                     ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: DISPLAY_WEAPONS
; Description: Displays available weapons and their ownership status.
;----------------------------------------------------------------
DISPLAY_WEAPONS:
                BSR     CLEAR_SCREEN    ; Clear display
                BSR     NEXT_LINE       ; Move to next line
                LEA     CHOOSE_WEAPON_MSG, A1  ; Load message prompting weapon selection
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap

                ; Display Bronze Axe status
                LEA     BRONZE_AXE_MSG, A1  ; Load Bronze Axe name
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap
                MOVE    BRONZE_AXE, D1  ; Load Bronze Axe ownership status
                MOVE    #3, D0          ; Set TRAP function for printing numeric value
                TRAP    #15             ; Call system trap
                LEA     OWNED_MSG, A1   ; Load "Owned" message
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap
                BSR     NEXT_LINE       ; Move to next line

                ; Display Iron Sword status
                LEA     IRON_SWORD_MSG, A1  ; Load Iron Sword name
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap
                MOVE    IRON_SWORD, D1  ; Load Iron Sword ownership status
                MOVE    #3, D0          ; Set TRAP function for printing numeric value
                TRAP    #15             ; Call system trap
                LEA     OWNED_MSG, A1   ; Load "Owned" message
                MOVE    #14, D0         ; Set TRAP function for printing string
                TRAP    #15             ; Call system trap
                BSR     NEXT_LINE       ; Move to next line
                RTS                     ; Return from subroutine
;----------------------------------------------------------------
; Subroutine: DISPLAY_SKILLS
; Description: Displays available skills for the mage class.
;----------------------------------------------------------------
DISPLAY_MAGE_SKILLS:
                BSR     CLEAR_SCREEN  ; Clear display
                BSR     NEXT_LINE     ; Advance to next line
                LEA     CHOOSE_SKILL_MSG, A1  ; Prompt user to choose a skill
                MOVE    #14, D0
                TRAP    #15
                
                LEA     FIREBOLT_MSG, A1  ; Load Firebolt skill message
                MOVE    #14, D0
                TRAP    #15
                MOVE    FIREBOLT, D1  ; Display Firebolt status
                MOVE    #3, D0
                TRAP    #15
                LEA     LEARNED_MSG, A1  ; Display "Learned" message if skill is known
                MOVE    #14, D0
                TRAP    #15
                BSR     NEXT_LINE     ; New line
                
                LEA     LIGHTNING_RAY_MSG, A1  ; Load Lightning Ray skill message
                MOVE    #14, D0
                TRAP    #15
                MOVE    LIGHTNING_RAY, D1  ; Display Lightning Ray status
                MOVE    #3, D0
                TRAP    #15
                LEA     LEARNED_MSG, A1  ; Display "Learned" message if skill is known
                MOVE    #14, D0
                TRAP    #15
                BSR     NEXT_LINE     ; New line
                RTS

;----------------------------------------------------------------
; Subroutine: DISPLAY_WARRIOR_SKILLS
; Description: Displays available skills for the warrior class.
;----------------------------------------------------------------
DISPLAY_WARRIOR_SKILLS:
                BSR     CLEAR_SCREEN  ; Clear display
                BSR     NEXT_LINE     ; Advance to next line
                LEA     CHOOSE_SKILL_MSG, A1  ; Prompt user to choose a skill
                MOVE    #14, D0
                TRAP    #15
                
                LEA     POWER_STRIKE_MSG, A1  ; Load Power Strike skill message
                MOVE    #14, D0
                TRAP    #15
                MOVE    POWER_STRIKE, D1  ; Display Power Strike status
                MOVE    #3, D0
                TRAP    #15
                LEA     LEARNED_MSG, A1  ; Display "Learned" message if skill is known
                MOVE    #14, D0
                TRAP    #15
                BSR     NEXT_LINE     ; New line
                
                LEA     CONCUSIVE_BLOW_MSG, A1  ; Load Concussive Blow skill message
                MOVE    #14, D0
                TRAP    #15
                MOVE    CONCUSIVE_BLOW, D1  ; Display Concussive Blow status
                MOVE    #3, D0
                TRAP    #15
                LEA     LEARNED_MSG, A1  ; Display "Learned" message if skill is known
                MOVE    #14, D0
                TRAP    #15
                BSR     NEXT_LINE     ; New line
                RTS  
     
;----------------------------------------------------------------
; Subroutine: NO_WEAPON_PROMPT
; Description: Displays a prompt when no weapon is available.
;----------------------------------------------------------------
NO_WEAPON_MSG:
                LEA     NO_WEAPONS_MSG, A1  ; Load "No Weapons" message
                MOVE    #14, D0
                TRAP    #15
                BSR     CONTINUE  ; Wait for player input before proceeding
                BRA     CHOOSE_OPTION  ; Return to the option selection menu

;----------------------------------------------------------------
; Subroutine: DISPLAY_COMBAT
; Description: Displays the current combat statistics.
;----------------------------------------------------------------
DISPLAY_COMBAT:
                BSR     CLEAR_SCREEN  ; Clear the screen before displaying stats
                
                ; Display Player Health
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$0001, D1  ; Column 00, Row 01
                TRAP    #15  ; Perform action
                LEA     HEALTH_MSG, A1  ; Load "Health" message
                MOVE    #14, D0  ; No line feed
                TRAP    #15  ; Display message
                
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$A01, D1  ; Column 10, Row 01
                TRAP    #15  ; Perform action
                MOVE.B  #03, D0  ; Display number at D1.L
                MOVE.W  HEALTH, D1  ; Move health value to D1.L
                TRAP    #15  ; Display value
                
                ; Display Player Damage
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$0002, D1  ; Column 00, Row 02
                TRAP    #15  ; Perform action
                LEA     DAMAGE_MSG, A1  ; Load "Damage" message
                MOVE    #14, D0  ; No line feed
                TRAP    #15  ; Display message
                
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$B02, D1  ; Column 10, Row 02
                TRAP    #15  ; Perform action
                MOVE.B  #03, D0  ; Display number at D1.L
                MOVE.W  DAMAGE, D1  ; Move damage value to D1.L
                TRAP    #15  ; Display value
                
                ; Display ENEMY Health
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$1E01, D1  ; Column 30, Row 03
                TRAP    #15  ; Perform action
                LEA     ENEMY_HEALTH_MSG, A1  ; Load "Health" message
                MOVE    #14, D0  ; No line feed
                TRAP    #15  ; Display message
                
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$1A01, D1  ; Column 26, Row 0
                TRAP    #15  ; Perform action
                MOVE.B  #03, D0  ; Display number at D1.L
                MOVE.W  ENEMY_HEALTH, D1  ; Move health value to D1.L
                TRAP    #15  ; Display value
                
                ; Display ENEMY Damage
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$1E02, D1  ; Column 30, Row 03
                TRAP    #15  ; Perform action
                LEA     ENEMY_DAMAGE_MSG, A1  ; Load "Damage" message
                MOVE    #14, D0  ; No line feed
                TRAP    #15  ; Display message
                
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$1A02, D1  ; Column 26, Row 03
                TRAP    #15  ; Perform action
                MOVE.B  #03, D0  ; Display number at D1.L
                MOVE.W  ENEMY_DAMAGE, D1  ; Move damage value to D1.L
                TRAP    #15  ; Display value
                
                ; Display Player Mana
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$0005, D1  ; Column 00, Row 03
                TRAP    #15  ; Perform action
                LEA     MANA_MSG, A1  ; Load "Mana" message
                MOVE    #14, D0  ; No line feed
                TRAP    #15  ; Display message
                
                MOVE.B  #11, D0  ; Set cursor position
                MOVE.W  #$A05, D1  ; Column 10, Row 03
                TRAP    #15  ; Perform action
                MOVE.B  #03, D0  ; Display number at D1.L
                MOVE.W  MANA, D1  ; Move mana value to D1.L
                TRAP    #15  ; Display value
                
                RTS  ; Return from subroutine
;----------------------------------------------------------------
; Subroutine: ADD_MANA_STAT
; Description: Displays the mana statistic if mana bonus is enabled.
;----------------------------------------------------------------
ADD_MANA_STAT:
                LEA     MANA_MSG, A1       ; Load the address of the mana message into A1
                MOVE    #14, D0            ; Set D0 to 14 for the message length
                TRAP    #15                ; Display the mana message
                MOVE    MANA, D1           ; Move the current mana value into D1
                MOVE    #3, D0             ; Set D0 to 3 for the length of the mana value
                TRAP    #15                ; Display the mana value
                BSR     NEXT_LINE          ; Call the subroutine to move to the next line
                LEA     INTELIGENCE_MSG, A1 ; Load the address of the intelligence message into A1
                MOVE    #14, D0            ; Set D0 to 14 for the message length
                TRAP    #15                ; Display the intelligence message
                MOVE    INTELIGENCE, D1    ; Move the intelligence value into D1
                MOVE    #3, D0             ; Set D0 to 3 for the length of the intelligence value
                TRAP    #15                ; Display the intelligence value
                BSR     NEXT_LINE          ; Call the subroutine to move to the next line
                RTS                        ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: ADD_DR_STAT
; Description: Displays the damage reduction statistic if enabled.
;----------------------------------------------------------------
ADD_DR_STAT:
                LEA     STRENGTH_MSG, A1    ; Load the address of the strength message into A1
                MOVE    #14, D0             ; Set D0 to 14 for the message length
                TRAP    #15                 ; Display the strength message
                MOVE    STRENGTH, D1        ; Move the strength value into D1
                MOVE    #3, D0              ; Set D0 to 3 for the length of the strength value
                TRAP    #15                 ; Display the strength value
                BSR     NEXT_LINE           ; Call the subroutine to move to the next line
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: SHOW_MAIN_MENU
; Description: Displays the main menu options for the day.
;----------------------------------------------------------------
SHOW_MAIN_MENU:
                LEA     BORDER, A1
                MOVE    #14, D0
                TRAP    #15
                BSR     NEXT_LINE
                LEA     MENU_OPTIONS, A1    ; Load the address of the menu options into A1
                MOVE    #14, D0             ; Set D0 to 14 for the message length
                TRAP    #15                 ; Display the main menu options
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: HANDLE_INPUT
; Description: Processes the player's main menu input.
;----------------------------------------------------------------
HANDLE_INPUT:
                CLR.L   D1                  ; Clear D1 register
                MOVE    #4, D0              ; Set D0 to 4 for the TRAP call
                TRAP    #15                 ; Get user input
                CMP     #1, D1              ; Compare input with option 1 (Train)
                BEQ     TRAIN_ACTION        ; Branch to TRAIN_ACTION if input is 1
                CMP     #2, D1              ; Compare input with option 2 (Stamina training)
                BEQ     STAMINA_TRAINING    ; Branch to STAMINA_TRAINING if input is 2
                CMP     #3, D1              ; Compare input with option 3 (Mercenary mission)
                BEQ     MERCENARY_MISSION   ; Branch to MERCENARY_MISSION if input is 3
                CMP     #4, D1              ; Compare input with option 4 (Shop)
                BEQ     SHOP_ACTION         ; Branch to SHOP_ACTION if input is 4
                CMP     #5, D1              ; Compare input with option 5 (Advance day)
                BEQ     START_COMBAT        ; Branch to START_COMBAT if input is 5
                BRA     MAIN_LOOP           ; Branch to MAIN_LOOP for invalid input
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: TRAIN_ACTION
; Description: Implements training to increase damage.
;----------------------------------------------------------------
TRAIN_ACTION:
                ; Increase damage and deduct actions
                MOVE.W  STRENGTH, D1        ; Move strength value into D1
                MOVE    DAMAGE, D2          ; Move current damage value into D2
                ADD.W   D1, D2              ; Add strength value to damage (increase damage)
                SUB.W   #1, ACTIONS         ; Subtract one action (deduct one action)
                LEA     SWORD_MISSION_MSG, A1 ; Load address of the sword mission message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the sword mission message
                BSR     CONTINUE            ; Call the CONTINUE subroutine
                MOVE    D2, DAMAGE          ; Update damage value
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: SHOP_ACTION
; Description: Displays the shop header and processes shop input.
;----------------------------------------------------------------
SHOP_ACTION:
                BSR     CLEAR_SCREEN        ; Call the CLEAR_SCREEN subroutine
                LEA     MONEY_MSG, A1       ; Load address of the money message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the money message
                MOVE    MONEY, D1           ; Move the current money value into D1
                MOVE    #3, D0              ; Set D0 to 3 for the money value length
                TRAP    #15                 ; Display the money value
                BSR     NEXT_LINE           ; Call the NEXT_LINE subroutine
                LEA     SHOP_HEADER, A1     ; Load address of the shop header
                MOVE    #14, D0             
                TRAP    #15                 ; Display the shop header
                LEA     SHOP_CHOICE_MSG, A1 ; Load address of the shop choice message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the shop choice message
                BSR     SHOP_CHOICE_INPUT   ; Call the SHOP_CHOICE_INPUT subroutine
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: SHOP_CHOICE_INPUT
; Description: Processes the player's input in the shop.
;----------------------------------------------------------------
SHOP_CHOICE_INPUT:
                MOVE    #4, D0              ; Set D0 to 4 for the TRAP call
                TRAP    #15                 ; Get user input
                CMP     #1, D1              ; Compare input with option 1 (Weapon shop)
                BEQ     WEAPON_SHOP_MENU    ; Branch to WEAPON_SHOP_MENU if input is 1
                CMP     #2, D1              ; Compare input with option 2 (Skill shop)
                BEQ     SKILL_SHOP_MENU     ; Branch to SKILL_SHOP_MENU if input is 2
                CMP     #3, D1              ; Compare input with option 3 (Back to main menu)
                BEQ     MAIN_LOOP           ; Branch to MAIN_LOOP if input is 3
                BRA     SHOP_CHOICE_INPUT   ; Invalid input, restart input loop
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: WEAPON_SHOP_MENU
; Description: Displays the weapon shop menu.
;----------------------------------------------------------------
WEAPON_SHOP_MENU:
                BSR     CLEAR_SCREEN        ; Call the CLEAR_SCREEN subroutine
                LEA     MONEY_MSG, A1       ; Load address of the money message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the money message
                MOVE    MONEY, D1           ; Move the current money value into D1
                MOVE    #3, D0              ; Set D0 to 3 for the money value length
                TRAP    #15                 ; Display the money value
                BSR     NEXT_LINE           ; Call the NEXT_LINE subroutine
                LEA     BORDER, A1          ; Load address of the border message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the border message
                BSR     NEXT_LINE           ; Call the NEXT_LINE subroutine
                LEA     WEAPON_SHOP_MSG, A1 ; Load address of the weapon shop message
                MOVE    #14, D0            
                TRAP    #15                 ; Display the weapon shop message
                BSR     WEAPON_SHOP_INPUT   ; Call the WEAPON_SHOP_INPUT subroutine
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: WEAPON_SHOP_INPUT
; Description: Processes input for weapon purchases.
;----------------------------------------------------------------
WEAPON_SHOP_INPUT:
                MOVE    #4, D0              ; Set D0 to 4 for the TRAP call
                TRAP    #15                 ; Get user input
                CMP     #1, D1              ; Compare input with option 1 (Buy weapon 1)
                BEQ     BUY_WEAPON_1        ; Branch to BUY_WEAPON_1 if input is 1
                CMP     #2, D1              ; Compare input with option 2 (Buy weapon 2)
                BEQ     BUY_WEAPON_2        ; Branch to BUY_WEAPON_2 if input is 2
                CMP     #3, D1              ; Compare input with option 3 (Back to shop action)
                BEQ     SHOP_ACTION         ; Branch to SHOP_ACTION if input is 3
                BRA     WEAPON_SHOP_INPUT   ; Invalid input, restart input loop
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: BUY_WEAPON_1
; Description: Processes the purchase of Bronze Axe.
;----------------------------------------------------------------
BUY_WEAPON_1:
                BSR     CLEAR_SCREEN        ; Call the CLEAR_SCREEN subroutine
                CMP     #30, MONEY          ; Compare money with the cost of the Bronze Axe (30)
                BLT     NO_MORE_MONEY       ; If not enough money, branch to NO_MORE_MONEY
                SUB     #30, MONEY          ; Deduct the cost of the Bronze Axe from money
                MOVE.W  #1, BRONZE_AXE      ; Set the Bronze Axe to 1 (purchased)
                LEA     BUY_WEAPON_1_MSG, A1 ; Load address of the purchase message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the purchase message
                BSR     CONTINUE            ; Call the CONTINUE subroutine
                BSR     SHOP_ACTION         ; Return to SHOP_ACTION subroutine
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: BUY_WEAPON_2
; Description: Processes the purchase of Iron Sword.
;----------------------------------------------------------------
BUY_WEAPON_2:
                BSR     CLEAR_SCREEN        ; Call the CLEAR_SCREEN subroutine
                CMP     #60, MONEY          ; Compare money with the cost of the Iron Sword (60)
                BLT     NO_MORE_MONEY       ; If not enough money, branch to NO_MORE_MONEY
                SUB     #60, MONEY          ; Deduct the cost of the Iron Sword from money
                MOVE.W  #1, IRON_SWORD      ; Set the Iron Sword to 1 (purchased)
                LEA     BUY_WEAPON_2_MSG, A1 ; Load address of the purchase message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the purchase message
                BSR     CONTINUE            ; Call the CONTINUE subroutine
                BSR     SHOP_ACTION         ; Return to SHOP_ACTION subroutine
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: SKILL_SHOP_MENU
; Description: Displays the skill shop menu.
;----------------------------------------------------------------
SKILL_SHOP_MENU:
                BSR     CLEAR_SCREEN        ; Call the CLEAR_SCREEN subroutine
                LEA     MONEY_MSG, A1       ; Load address of the money message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the money message
                MOVE    MONEY, D1           ; Move current money value into D1
                MOVE    #3, D0              ; Set D0 to 3 for the money value length
                TRAP    #15                 ; Display the money value
                BSR     NEXT_LINE           ; Call the NEXT_LINE subroutine
                CMP     #1, MAGE_BOOL       ; Check if the player is a Mage
                BEQ     MAGE_SHOP           ; Branch to MAGE_SHOP if player is Mage
                CMP     #1, WARRIOR_BOOL    ; Check if the player is a Warrior
                BEQ     WARRIOR_SHOP        ; Branch to WARRIOR_SHOP if player is Warrior
                BSR     CONTINUE            ; Call the CONTINUE subroutine if neither
                RTS                         ; Return from subroutine

MAGE_SHOP:
                LEA     MAGE_SHOP_MSG, A1    ; Load address of the Mage shop message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the Mage shop message
                BSR     CONTINUE            ; Call the CONTINUE subroutine
                CMP     #1, D1              ; Compare input with option 1 (Buy Mage Skill 1)
                BEQ     BUY_MAGE_SKILL_1    ; Branch to BUY_MAGE_SKILL_1 if input is 1
                CMP     #2, D1              ; Compare input with option 2 (Buy Mage Skill 2)
                BEQ     BUY_MAGE_SKILL_2    ; Branch to BUY_MAGE_SKILL_2 if input is 2
                BRA     SHOP_ACTION         ; Invalid input, go back to SHOP_ACTION
        
WARRIOR_SHOP:
                LEA     WARRIOR_SHOP_MSG, A1   ; Load address of the Warrior shop message
                MOVE    #14, D0               
                TRAP    #15                    ; Display the Warrior shop message
                BSR     CONTINUE               ; Call the CONTINUE subroutine
                CMP     #1, D1                 ; Compare input with option 1 (Buy Warrior Skill 1)
                BEQ     BUY_WARRIOR_SKILL_1    ; Branch to BUY_WARRIOR_SKILL_1 if input is 1
                CMP     #2, D1                 ; Compare input with option 2 (Buy Warrior Skill 2)
                BEQ     BUY_WARRIOR_SKILL_2    ; Branch to BUY_WARRIOR_SKILL_2 if input is 2
                BRA     SHOP_ACTION            ; Invalid input, go back to SHOP_ACTION

;----------------------------------------------------------------
; Subroutine: BUY_MAGE_SKILL
; Description: Processes the purchase of the mage skills.
;----------------------------------------------------------------
BUY_MAGE_SKILL_1:
                BSR     CLEAR_SCREEN           ; Call the CLEAR_SCREEN subroutine
                MOVE.W  #1, FIREBOLT           ; Set FIREBOLT skill to 1 (purchased)
                CMP     #50, MONEY             ; Compare money with the cost of Firebolt (50)
                BLT     NO_MORE_MONEY          ; If not enough money, branch to NO_MORE_MONEY
                SUB     #50, MONEY             ; Deduct the cost of Firebolt from money
                LEA     BUY_MAGE_SKILL_1_MSG, A1 ; Load address of the purchase message
                MOVE    #14, D0               
                TRAP    #15                    ; Display the purchase message
                BSR     CONTINUE               ; Call the CONTINUE subroutine
                BSR     SHOP_ACTION            ; Return to SHOP_ACTION subroutine
                RTS                            ; Return from subroutine

BUY_MAGE_SKILL_2:
                BSR     CLEAR_SCREEN           ; Call the CLEAR_SCREEN subroutine
                MOVE.W  #1, LIGHTNING_RAY      ; Set LIGHTNING_RAY skill to 1 (purchased)
                CMP     #100, MONEY            ; Compare money with the cost of Lightning Ray (100)
                BLT     NO_MORE_MONEY          ; If not enough money, branch to NO_MORE_MONEY
                SUB     #100, MONEY            ; Deduct the cost of Lightning Ray from money
                LEA     BUY_MAGE_SKILL_2_MSG, A1 ; Load address of the purchase message
                MOVE    #14, D0                
                TRAP    #15                    ; Display the purchase message
                BSR     CONTINUE               ; Call the CONTINUE subroutine
                BSR     SHOP_ACTION            ; Return to SHOP_ACTION subroutine
                RTS                            ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: BUY_WARRIOR_SKILL
; Description: Processes the purchase of the warrior skills.
;----------------------------------------------------------------
BUY_WARRIOR_SKILL_1:
                BSR     CLEAR_SCREEN           ; Call the CLEAR_SCREEN subroutine
                MOVE.W  #1, POWER_STRIKE       ; Set POWER_STRIKE skill to 1 (purchased)
                CMP     #50, MONEY             ; Compare money with the cost of Power Strike (50)
                BLT     NO_MORE_MONEY          ; If not enough money, branch to NO_MORE_MONEY
                SUB     #50, MONEY             ; Deduct the cost of Power Strike from money
                LEA     BUY_WARRIOR_SKILL_1_MSG, A1 ; Load address of the purchase message
                MOVE    #14, D0                
                TRAP    #15                    ; Display the purchase message
                BSR     CONTINUE               ; Call the CONTINUE subroutine
                BSR     SHOP_ACTION            ; Return to SHOP_ACTION subroutine
                RTS                            ; Return from subroutine
BUY_WARRIOR_SKILL_2:
                BSR     CLEAR_SCREEN           ; Call the CLEAR_SCREEN subroutine
                MOVE.W  #1, CONCUSIVE_BLOW     ; Set CONCUSIVE_BLOW skill to 1 (purchased)
                CMP     #100, MONEY            ; Compare money with the cost of Concussive Blow (100)
                BLT     NO_MORE_MONEY          ; If not enough money, branch to NO_MORE_MONEY
                SUB     #100, MONEY            ; Deduct the cost of Concussive Blow from money
                LEA     BUY_WARRIOR_SKILL_2_MSG, A1 ; Load address of the purchase message
                MOVE    #14, D0                
                TRAP    #15                    ; Display the purchase message
                BSR     CONTINUE               ; Call the CONTINUE subroutine
                BSR     SHOP_ACTION            ; Return to SHOP_ACTION subroutine
                RTS                            ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: STAMINA_TRAINING
; Description: Recovers player health via stamina training.
;----------------------------------------------------------------
STAMINA_TRAINING:
                ; Recover health and deduct an action
                MOVE    HEALTH, D1             ; Move current health into D1
                MOVE    STRENGTH, D2           ; Move strength value into D2
                MULU    #2, D2                 ; Multiply strength by 2 
                ADD     D1, D2                 ; Add current health to the result for increased recovery
                ADD.W   #10, D2                ; Increase health by 20
                MOVE    D2, HEALTH             ; Move the updated health value back into HEALTH
                SUB.W   #1, ACTIONS            ; Deduct one action (used for training)
                LEA     STAMINA_TRAINING_MSG, A1 ; Load address of the stamina training message
                MOVE    #14, D0                ; 
                TRAP    #15                    ; Display the stamina training message
                BSR     CONTINUE               ; Call the CONTINUE subroutine
                MOVE    #3, D0                 
                TRAP    #15                    ; Display another message or operation
                RTS                            ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: MERCENARY_MISSION
; Description: Completes a mercenary mission to earn money.
;----------------------------------------------------------------
MERCENARY_MISSION:
                SUB     #1, ACTIONS     ; Deduct one action for completing the mission
                ADD     #5, MONEY      ; Add 15 money from the mission
                LEA     MERCENARY_MISSION_MSG, A1 ; Load address of the mission completion message
                MOVE    #14, D0         
                TRAP    #15             ; Display the mission completion message
                BSR     CONTINUE        ; Wait for player input to continue
                RTS                     ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: NO_MORE_MONEY
; Description: Informs the player when there is insufficient money.
;----------------------------------------------------------------
NO_MORE_MONEY:
                LEA     NO_MONEY_MSG, A1    ; Load address of the "No Money" message
                MOVE    #14, D0             
                TRAP    #15                 ; Display the "No Money" message
                BSR     CONTINUE            ; Wait for player input to continue
                RTS                         ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: CONTINUE
; Description: Waits for player input to continue.
;----------------------------------------------------------------
CONTINUE:
                BSR     NEXT_LINE            ; Call NEXT_LINE to move to a new line
                MOVE.B  #4, D0               ; Set input mode for continue action
                TRAP    #15                  ; Wait for player input to continue
                RTS                          ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: ADVANCE_DAY
; Description: Advances the day counter and resets daily actions.
;----------------------------------------------------------------
ADVANCE_DAY:
                ADDQ.W  #1, DAY              ; Increment the day counter by 1
                MOVE.W  #10, ACTIONS         ; Reset daily actions to 10
                RTS                           ; Call the next subroutine (possibly to handle more actions or updates)

;----------------------------------------------------------------
; Subroutine: CHECK_ACTIONS
; Description: Checks remaining actions and advances day if none.
;----------------------------------------------------------------
CHECK_ACTIONS:
                MOVE    ACTIONS, D0          ; Move the current number of actions into D0
                CMP     #0, D0               ; Compare the remaining actions with 0
                BLE     ADVANCE_DAY          ; If no actions are left (0 or negative), advance the day
                RTS                          ; Return from subroutine if there are actions left

;----------------------------------------------------------------
; Subroutine: CLEAR_SCREEN
; Description: Clears the display and resets the cursor.
;----------------------------------------------------------------
CLEAR_SCREEN:
                MOVE.W  #$FF00, D1           ; Set clear screen parameter to clear the screen
                MOVE.W  #11, D0              ; Set the display function
                TRAP    #15                  ; Call trap to execute the screen clear
                RTS                          ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: NEXT_LINE
; Description: Advances the display to the next line.
;----------------------------------------------------------------
NEXT_LINE:
                LEA     CRLF, A1             ; Load the carriage return line feed address
                MOVE    #14, D0              
                TRAP    #15                  ; Call trap to display the newline
                RTS                           ; Return from subroutine

;----------------------------------------------------------------
; Subroutine: GAME_OVER
; Description: Displays the Game Over message and halts execution.
;----------------------------------------------------------------
GAME_OVER:
                LEA     GAMEOVER_MSG, A1      ; Load the Game Over message address
                MOVE    #14, D0               
                TRAP    #15                   ; Display the Game Over message
                SIMHALT                       ; Halt the execution of the program

;****************************************************************
; Data & String Declarations
;****************************************************************

; Game state variables
HEALTH              DC.W    50
DAMAGE              DC.W    10
MANA                DC.W    50
MONEY               DC.W    50
ACTIONS             DC.W    10
STRENGTH            DC.W    0
INTELIGENCE         DC.W    0
LIVES               DC.W    3
DAY                 DC.W    1
FLOOR               DC.W    1
RESTRICTION         DC.W    0
RESTRICTION_DAYS    DC.W    0
MAGE_BOOL           DC.W    0
WARRIOR_BOOL        DC.W    0
ENEMY_HEALTH        DC.W    1
ENEMY_DAMAGE        DC.W    1
EQUIPPED_WEAPON     DC.W    0
EQUIPPED_SKILL      DC.W    0
BRONZE_AXE          DC.W    0
BRONZE_AXE_DMG      DC.W    10
IRON_SWORD          DC.W    0
IRON_SWORD_DMG      DC.W    20
FIREBOLT            DC.W    0
FIREBOLT_DMG        DC.W    30
LIGHTNING_RAY       DC.W    0
LIGHTNING_RAY_DMG   DC.W    60
POWER_STRIKE        DC.W    0
POWER_STRIKE_DMG    DC.W    25
CONCUSIVE_BLOW      DC.W    0
CONCUSIVE_BLOW_DMG  DC.W    50
FIRST_EVENT_FLAG    DC.W    0
MANA_COST           DC.W    0

; String definitions
WELCOME_MSG_1               DC.B    'Welcome to the Tower of Destiny',13,10,0
WELCOME_MSG_2               DC.B    'You must be confused, dont worry about it',13,10,0
WELCOME_MSG_3               DC.B    'the answers you desire reside at the top of the tower.',13,10,0
WELCOME_MSG_4               DC.B    'All you have to do is get stronger',13,10,0
WELCOME_MSG_5               DC.B    'And climb',13,10,0
WELCOME_MSG_6               DC.B    'Good luck',13,10,0
MENU_OPTIONS                DC.B    'Daily Options:',13,10
                            DC.B    '1. Sword training (+2 damage for 1 actions)',13,10
                            DC.B    '2. Stamina training(+10 health for 1 actions)',13,10
                            DC.B    '3. Mercenary missions (5g for 1 actios)',13,10
                            DC.B    '4. Shop',13,10
                            DC.B    '5. Next floor',13,10
                            DC.B    'What next? ',0
STAMINA_TRAINING_MSG        DC.B    'Training completed, your stamina went up',13,10,0
SHOP_HEADER                 DC.B    '--- DIMENSIONAL SHOP ---',13,10,0
NO_MONEY_MSG                DC.B    'Not enough money',0
ENEMY_HEALTH_MSG            DC.B    ' :Enemy Health |',0
ENEMY_DAMAGE_MSG            DC.B    ' :Enemy damage |',0
HEALTH_MSG                  DC.B    '| Health: ',0
DAMAGE_MSG                  DC.B    '| Damage: ',0
MANA_MSG                    DC.B    '| Mana: ',0
MONEY_MSG                   DC.B    '| Money: ',0
ACTIONS_MSG                 DC.B    '| Actions: ',0
LIVES_MSG                   DC.B    '| Lives: ',0
STRENGTH_MSG                DC.B    '| Strength: ',0
INTELIGENCE_MSG             DC.B    '| Inteligence: ',0
SHOP_PROMPT                 DC.B    'Select item: ',0
CRLF                        DC.B    $0D, $0A, 0
DAY_MSG:                    DC.B    'DAY: ',0
FLOOR_MSG:                  DC.B    'FLOOR: ',0
SHOP_CHOICE_MSG             DC.B    '| 1. Weapons',13,10
                            DC.B    '| 2. Skill',13,10
                            DC.B    '| 3. Back',13,10
                            DC.B    '| Which do you choose?',13,10,0
CHOOSE_OPTION_MSG           DC.B    '| -----Turn actions----',13,10
                            DC.B    '| 1. Attack',13,10
                            DC.B    '| 2. Use weapon',13,10
                            DC.B    '| 3. Use skill',13,10
                            DC.B    '| Which do you choose?',13,10,0
WEAPON_SHOP_MSG             DC.B    '| 1. Bronze Axe ------20 Gold------',13,10
                            DC.B    '| 2. Iron sword ------50 Gold------',13,10
                            DC.B    '| 3. Back',13,10
                            DC.B    '| Which do you choose?',13,10,0
BRONZE_AXE_MSG              DC.B    '| 1. Bronze axe ',0
IRON_SWORD_MSG              DC.B    '| 2. Iron sword ',0
FIREBOLT_MSG                DC.B    '| 1. Firebolt ',0
LIGHTNING_RAY_MSG           DC.B    '| 2. Lightning ray ',0
POWER_STRIKE_MSG            DC.B    '| 1. Power strike ',0
CONCUSIVE_BLOW_MSG          DC.B    '| 2. Concusive blow ',0
OWNED_MSG                   DC.B    ' Owned ',0
LEARNED_MSG                 DC.B    ' Learned',0
SWORD_MISSION_MSG           DC.B    ' Damage increased ',13,10,0
BUY_WEAPON_1_MSG            DC.B    '| Congratulations you have purchased Bronze Axe',13,10
                            DC.B    '| Bronze axe increases your damage by 5',13,10,0
BUY_WEAPON_2_MSG            DC.B    '| Congratulations you have purchased Iron sword',13,10
                            DC.B    '| Iron sword increases your damage by 10',13,10,0
BUY_WEAPON_3_MSG            DC.B    '| Congratulations you have purchased Magic Staff',13,10
                            DC.B    '| Magic staff increases mana by 10',13,10,0
NO_WEAPONS_MSG              DC.B    '| No weapons in the inventory',13,10,0
NO_SKILL_MSG                DC.B    '| You do not own this skill',13,10,0
FIRST_EVENT_MSG             DC.B    '| Congratulations!|',13,10,10
                            DC.B    '| You have decided to actually try climbing the tower',13,10,10
                            DC.B    '| You are much better than I though',13,10,10
                            DC.B    '| Now it is time to take the next step',13,10,10
                            DC.B    '| Choose your new path and grow stronger!',13,10,10
                            DC.B    '| ---------------------Choose well -----------------|',13,10
                            DC.B    '| 1. Mage', 13, 10
                            DC.B    '| 2. Warrior', 13, 10 
                            DC.B    '| --------------------------------------------------|',13,10,0
BUY_MAGE_SKILL_1_MSG        DC.B    '| Congratulations you have purchased Firebolt',13,10,0
BUY_MAGE_SKILL_2_MSG        DC.B    '| Congratulations you have purchased Lightning Ray',13,10,0
BUY_WARRIOR_SKILL_1_MSG     DC.B    '| Congratulations you have purchased Power strike',13,10,0
BUY_WARRIOR_SKILL_2_MSG     DC.B    '| Congratulations you have purchased Concusive blow',13,10,0
USE_WEAPON_1_MSG            DC.B    '| used bronze axe',13,10,0
CHOOSE_WEAPON_MSG           DC.B    'Choose weapon', 13,10,0
CHOOSE_SKILL_MSG            DC.B    'Choose skill',13,10,0
DAMAGE_DEALT_MSG            DC.B    'You dealt: ', 0
ENEMY_DAMAGE_DEALT_MSG      DC.B    'Enemey dealt: ',0
DAMAGE_LITERAL_MSG          DC.B    ' Damage',0
MAGE_SHOP_MSG               DC.B    '|  -------------Mage shop-------------',13,10
                            DC.B    '| 1. Firebolt------------50 Gold------',13,10
                            DC.B    '| 2. Lightning ray ------100 Gold-----',13,10
                            DC.B    '| 3. Back',13,10,0
                            DC.B    '| Which do you choose?',13,10,0
WARRIOR_SHOP_MSG            DC.B    '|  -------------Warrior shop------------ ',13,10
                            DC.B    '| 1. Power strike   ---------50 Gold----',13,10
                            DC.B    '| 2. Concussive blow------100 Gold------',13,10
                            DC.B    '| 3. Back',13,10,0
                            DC.B    '| Which do you choose?',13,10,0
MAGE_ACCEPT_MSG             DC.B    '| --You have selected Mage-- |',13,10
                            DC.B    '| --Now now have access to the Inteligence stat.',13,10
                            DC.B    '| --Inteligence boosts your skill damage and your mana pool',0
WARRIOR_ACCEPT_MSG          DC.B    '| --You have selected Warrior-- |',13,10
                            DC.B    '| --Now now have access to the Strength stat.',13,10
                            DC.B    '| --Strength boosts your damage and training stats',13,10,0
FIRST_ENEMY_DEFEAT_MSG      DC.B    'You have defeated your first enemy',13,10
                            DC.B    'Congratulations',13,10,0
PLAYER_DEFEAT_MSG           DC.B    'You have been defeated.',13,10 
                            DC.B    'Good luck in getting stronger',0
FIRST_FLOOR_CLEAR_MSG       DC.B    'You have finally cleared the first floor i was not expecting you to pass',13,10
                            DC.B     'Congratulations',13,10,0
GAMEOVER_MSG                DC.B    'Game Over! Thanks for playing!',13,10,0
NO_CLASS_MSG                DC.B    'You do not have the appropriate class',13,10,0
NO_MANA_MSG                 DC.B    'Not enough mana',13,10,0
INT_INCREASE_MSG            DC.B    'Inteligence increased by 2',13,10,0
STR_INCREASE_MSG            DC.B    'Strength increased by 2',13,10,0
MERCENARY_MISSION_MSG       DC.B    'Your mission was succesfull',13,10,10,0
INVALID_INPUT_MSG           DC.B    'Invalid input',13,10,0
CONTINUE_MSG:               DC.B    'Next',0
BORDER                      DC.B    '|--------------------------------------------------|',0

                END     START   









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

Game Plan & Vision

Overview

This project is a small 3D mobile-friendly action / tower-defense game inspired by the gameplay loop seen in the Kingshot playable ad, rather than the full Kingshot game.

The goal is to create short, replayable levels where the player moves around the battlefield, fights enemies, collects resources, builds defenses, and upgrades the battlefield while surviving enemy waves.

The player participates in combat, but the player is not supposed to be the main source of damage. Their main role is managing the battlefield.

Core Player Fantasy

The player should feel like a battlefield manager who is physically present in the fight.

They:

move around the battlefield

automatically shoot nearby enemies

collect coins/resources

spend coins to construct buildings

collect resources generated/stored by towers

choose which defenses to build when choices are available

upgrade defenses and possibly themselves

react to enemy waves and changing threats

The towers and defenses should remain extremely important. The player should help the defense rather than replacing it.

As a rough design philosophy:

Player combat contribution: ~40%
Tower / defense contribution: ~60%

These numbers are not strict balancing targets. They simply describe the intended relationship between the player and the defenses.

Core Gameplay Loop

Start Level
	↓
Fight enemies
	↓
Collect coins/resources
	↓
Build mandatory structures
	↓
Choose optional structures where available
	↓
Collect tower-generated/stored coins
	↓
Upgrade defenses / player
	↓
Survive increasingly difficult waves
	↓
Complete the level
	↓
Save earned progression
	↓
Next Level

If the player loses:

LEVEL LOST
	↓
Restart current level
	↓
Lose everything earned during that attempt

Progress only becomes permanent after successfully completing the level.

Level Structure

The game will use separate short levels instead of one enormous continuously expanding map.

Target level length:

Approximately 1–5 minutes.

Each level should be a relatively small self-contained battlefield.

This makes the game:

easier to balance

easier to develop

more suitable for mobile

easier to optimize

easier to replay

easier to introduce new mechanics gradually

Only the current level needs to be loaded.

Chapters

Levels will be grouped into chapters.

Example structure:

Chapter 1
├── Level 1
├── Level 2
├── Level 3
├── Level 4
└── Level 5

Chapter 2
├── Level 1
├── Level 2
├── Level 3
└── ...

Each chapter can introduce its own identity.

Possible differences between chapters:

environment/theme

enemy types

tower types

battlefield layouts

hazards

new mechanics

new upgrade possibilities

different path configurations

For example:

Chapter 1 — Grasslands
Chapter 2 — Desert
Chapter 3 — Snow
Chapter 4 — Ruined City
Chapter 5 — Volcanic Lands

These are examples rather than final themes.

Progression

Progression is persistent between completed levels.

Example:

Level 1 completed
→ upgrades/resources earned become permanent

Level 2 starts
→ player keeps permanent progression

Level 2 failed
→ everything earned during that Level 2 attempt disappears

Level 2 restarted
→ player starts again from the permanent state they had after Level 1

This creates two categories of state.

Persistent State

Eventually this may include:

player upgrades

unlocked tower types

permanent tower upgrades

chapter progress

unlocked levels

abilities

permanent currencies/resources

Temporary Level State

Examples:

coins collected during the current attempt

towers constructed during the current level

temporary upgrades

enemies killed

current wave

tower coin storage

temporary buffs

Temporary progress is committed to persistent progression only when the level is completed.

A central GameManager or similar state system will eventually handle this separation, but it does not need to be implemented until the core gameplay systems are working.

Building System

Building is one of the central mechanics.

The game will use two kinds of build locations.

Mandatory Build Spots

Some locations require a specific structure.

Example:

Build Spot
→ Archer Tower

The player simply spends the required resources to construct it.

These spots allow levels to be designed around specific defenses.

Choice Build Spots

Other locations allow the player to choose what to construct.

Example:

Build Spot
├── Archer Tower
├── Cannon Tower
└── Mage Tower

This introduces strategy.

A player may choose differently depending on:

enemy types

available resources

battlefield layout

current upgrades

upcoming waves

The game will therefore combine designed/predetermined defenses with player-controlled strategic choices.

Towers

The first working tower is currently an Archer Tower.

Current behavior:

detects nearby enemies

rotates the Archer toward its target

shoots automatically

bullets track their target

kills generate coins stored inside the tower

the player can collect those coins from the tower's CoinPlatform

Future tower possibilities include:

Archer Tower

Fast attacks against normal enemies.

Cannon Tower

Slow attacks with high damage and potentially area damage.

Mage Tower

Special attacks, elemental effects, or attacks useful against armored enemies.

Other tower types can be added later if they create meaningful strategic differences.

Tower Upgrades

Towers should eventually be upgradeable.

Example:

Archer Tower Lv.1
    ↓
Archer Tower Lv.2
    ↓
Archer Tower Lv.3

Possible upgrade effects:

faster attack speed

increased range

more damage

multi-shot

special attacks

increased coin storage

visual upgrades

Upgrades should visibly change the tower when possible so progression feels physical rather than purely numerical.

Enemies

The game should eventually contain several enemy types.

Possible examples:

Normal Enemy

Standard movement and durability.

Fast Enemy

Low health but reaches the base quickly.

Tank Enemy

Slow but difficult to kill.

Swarm Enemy

Weak enemies appearing in large numbers.

Runner

Attempts to quickly bypass defenses.

Future enemies may also have:

armor

shields

resistances

special abilities

different movement behavior

Enemy variety should force the player to reconsider tower choices and positioning.

Enemy Paths

Enemies travel along predefined Path3D routes toward the player's base.

Levels may contain:

one enemy path

multiple paths

multiple spawners

enemies attacking from different directions

Different path configurations can create variety without requiring entirely new systems.

For example:

Level A
Enemies → Base

Level B
Enemies ↘
		  Base
Enemies ↗

Level C
Enemies → split paths → Base

Waves

Enemies arrive in waves.

Current prototype behavior:

first wave contains 10 enemies

enemies spawn approximately once per second

after the wave finishes spawning, there is a short break

the next wave increases the enemy count

The final wave system may eventually control:

enemy composition

spawn speed

number of enemies

enemy paths

special enemies

bosses

wave announcements

Difficulty should not simply be:

"Every level has 20% more enemies."

Instead, difficulty should come from combinations of:

enemy types

enemy paths

tower choices

resource limitations

battlefield layouts

wave compositions

new mechanics

Player Combat

The player automatically shoots enemies inside their detection range.

The player currently:

moves using the joystick

detects nearby enemies

automatically selects targets

shoots projectiles

gains coins from kills

The player should remain useful in combat, especially when:

a defense line is struggling

fast enemies get through

one path needs temporary support

the player needs resources quickly

However, the player should not be able to comfortably defeat entire waves while ignoring towers.

Player Abilities

Abilities may be introduced later.

Possible examples:

temporary rapid fire

area attack

freeze

knockback

healing/repair

movement boost

temporary tower buff

Abilities should give the player important tactical decisions without turning the game into a pure action shooter.

Base

Enemies attempt to reach the player's base.

The base has health.

When an enemy reaches the end of its path:

Enemy reaches Base
→ Base takes damage
→ Enemy disappears

If base health reaches zero:

BASE DESTROYED
→ Level Lost
→ Restart Level

Possible future base upgrades:

increased health

regeneration

defensive weapon

shield

emergency ability

Resource / Coin System

Coins currently come from defeating enemies.

There are two resource flows.

Player Kills

Player kills enemy
→ Player receives coin

Tower Kills

Tower kills enemy
→ Coin stored in Tower
→ Player walks onto CoinPlatform
→ Coins transfer to Player

This creates movement around the battlefield.

Instead of standing in one location, the player needs to move between:

enemies

build spots

towers

coin collection platforms

upgrades

This supports the intended battlefield-manager role.

Visual Feedback / Polish

Once the gameplay systems are stable, the game should receive strong visual feedback.

Potential additions:

floating +1 coin text

coins flying toward the player

construction animations

tower upgrade animations

enemy hit effects

enemy death effects

muzzle flashes

projectile trails

damage numbers

wave announcements

base damage feedback

build progress indicators

tower coin indicators

screen effects for major events

The goal is to make simple actions feel satisfying without making the screen difficult to read on mobile.

Mobile Design

The game should be designed with mobile constraints in mind.

Important principles:

small levels

simple controls

readable UI

limited number of active enemies when possible

lightweight scenes

reusable enemy/tower scenes

avoid unnecessarily huge maps

avoid excessive physics calculations

keep visual effects readable and optimized

The player should ideally be able to understand most actions through movement and proximity rather than complicated menus.

Current Prototype Systems

The prototype already has the foundation for:

3D player movement

virtual joystick input

player enemy detection

automatic player shooting

target-tracking bullets

enemy spawning

reusable enemy spawners

multiple enemy paths

enemies following Path3D

base damage

enemy waves

build spots

gradual coin spending while standing on a build platform

tower construction

reusable BuildSpot scenes

Archer Tower

tower enemy detection

tower aiming

automatic tower shooting

tower coin storage

CoinPlatform collection

This means the basic gameplay loop already exists in prototype form:

Enemies spawn
→ enemies move toward base
→ player fights enemies
→ player earns coins
→ player spends coins on BuildSpot
→ tower is constructed
→ tower fights enemies
→ tower stores coins
→ player collects tower coins
→ resources can be reinvested

Planned Development Direction

The immediate goal is not to build every progression system at once.

The priority is to finish and validate the gameplay first.

A sensible development order is:

Stabilize the current tower/build/coin systems.

Add tower upgrades.

Add additional enemy types.

Improve wave progression.

Add another meaningful tower type.

Experiment with player abilities.

Create an actual Level 1 with a beginning and ending.

Add win/loss handling and restarting.

Introduce persistent progression between levels.

Build chapter/level selection.

Add visual/audio polish.

Balance and optimize for mobile.

This order can change as the prototype develops.

Design Principles

When deciding whether to add a mechanic, ask:

Does it give the player an interesting decision?

Good:

"Do I build an Archer Tower or save for a Cannon?"

Less useful:

"Press this button because it is always the correct choice."

Does it support the battlefield-manager role?

The player should frequently move between combat, building, collecting, and upgrading.

Does it create meaningful level variety?

New content should change how the player approaches the level rather than only increasing enemy health.

Is it readable on mobile?

Mechanics should remain understandable on a relatively small screen.

Is it worth the development complexity?

The project should stay achievable. A small polished game is preferable to a huge unfinished system.

Current Vision in One Sentence

A mobile-friendly 3D action/tower-defense game made of short chapter-based levels, where the player runs around the battlefield fighting enemies, collecting resources, constructing and upgrading defenses, and making strategic building choices while trying to protect the base and carry progression into future levels.

Status

Current phase: Core gameplay prototype.

The focus right now is making the fundamental combat, tower, resource, building, enemy, and wave systems fun and reliable before implementing the larger progression and chapter systems.

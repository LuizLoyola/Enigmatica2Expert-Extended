import crafttweaker.item.IItemStack as IItemStack;
import crafttweaker.item.IIngredient as IIngredient;
#modloaded thaumcraft

# Crimson Rites
scripts.wrap.thaumcraft.Infusion.registerRecipe("crimson_rites", "INFUSION", 
<thaumcraft:curio:6>, 15, 
[<aspect:vitium> * 30, <aspect:mortuus> * 15, <aspect:praecantatio> * 30, <aspect:auram> * 10], 
<thaumcraft:thaumonomicon>, 
[<thaumcraft:ingot>, <thaumcraft:void_seed>, <thaumcraft:salis_mundus>, <thaumcraft:void_seed>, <thaumcraft:salis_mundus>, <thaumcraft:void_seed>, <thaumcraft:ingot>, <thaumcraft:void_seed>]);

# Cultist Portal
scripts.wrap.thaumcraft.Infusion.registerRecipe("spawn_lesser_crimson_portal", "INFUSION", 
<minecraft:spawn_egg>.withTag({EntityTag: {id: "thaumcraft:cultistportallesser"}}), 15, 
[<aspect:vitium> * 90, <aspect:mortuus> * 45, <aspect:praecantatio> * 90, <aspect:auram> * 30], 
utils.tryCatch("openblocks:golden_egg", <minecraft:golden_apple:1>), 
[<thaumcraft:metal_thaumium>, <thaumcraft:void_seed>, <thaumcraft:salis_mundus>, <thaumcraft:void_seed>, <minecraft:skull:1>, <thaumcraft:void_seed>, <extrautils2:teleporter:1>, <thaumcraft:void_seed>]);

# Unification for the Smelting Bonus
// IIngredient input, IItemStack stack
mods.thaumcraft.SmeltingBonus.removeSmeltingBonus(<ore:oreCopper>, <thaumcraft:nugget:1>);
mods.thaumcraft.SmeltingBonus.removeSmeltingBonus(<ore:oreTin>, <thaumcraft:nugget:2>);
mods.thaumcraft.SmeltingBonus.removeSmeltingBonus(<ore:oreSilver>, <thaumcraft:nugget:3>);
mods.thaumcraft.SmeltingBonus.removeSmeltingBonus(<ore:oreLead>, <thaumcraft:nugget:4>);

mods.thaumcraft.SmeltingBonus.removeSmeltingBonus(<ore:clusterCopper>, <thaumcraft:nugget:1>);
mods.thaumcraft.SmeltingBonus.removeSmeltingBonus(<ore:clusterTin>, <thaumcraft:nugget:2>);
mods.thaumcraft.SmeltingBonus.removeSmeltingBonus(<ore:clusterSilver>, <thaumcraft:nugget:3>);
mods.thaumcraft.SmeltingBonus.removeSmeltingBonus(<ore:clusterLead>, <thaumcraft:nugget:4>);

// IIngredient input, WeightedItemStack stack
scripts.wrap.thaumcraft.SmeltingBonus.addSmeltingBonus(<ore:oreCopper>, <thermalfoundation:material:192> % 33);
scripts.wrap.thaumcraft.SmeltingBonus.addSmeltingBonus(<ore:oreTin>, <thermalfoundation:material:193> % 33);
scripts.wrap.thaumcraft.SmeltingBonus.addSmeltingBonus(<ore:oreSilver>, <thermalfoundation:material:194> % 33);
scripts.wrap.thaumcraft.SmeltingBonus.addSmeltingBonus(<ore:oreLead>, <thermalfoundation:material:195> % 33);

# Removing wrong aspects from stuff
	<ic2:dust:21>.setAspects(<aspect:metallum> * 1);
	<conarm:armor_trim:*>.setAspects(<aspect:terra>);

# [Void Seed*4] from [Insanium Essence][+4]
craft.remake(<thaumcraft:void_seed> * 4, ["pretty",
  "A I A",
  "© T ©",
  "T E T"], {
  "A": <exnihilocreatio:item_material:3>, # Ancient Spores
  "E": <ore:runeEnvyB>,                   # Rune of Envy
  "©": <contenttweaker:blasted_coal>,     # Blasted Coal
  "I": <ore:essenceInsanium>,             # Insanium Essence
  "T": <thaumcraft:taint_rock>|<thaumcraft:taint_soil>|<thaumcraft:taint_crust>, # Tainted Rock
});

# Wood Table
	recipes.remove(<thaumcraft:table_wood>);
	recipes.addShapedMirrored("Wood Table", 
	<thaumcraft:table_wood>, 
	[[null, null, null],
	[<ore:slabTreatedWood>, <ore:slabTreatedWood>, <ore:slabTreatedWood>],
	[<ore:plankTreatedWood>, null, <ore:plankTreatedWood>]]);

# Amber Block
	recipes.removeByRecipeName("thaumcraft:ambertoblock");
	recipes.addShapeless("Thaumcraft Amber Block", 
	<thaumcraft:amber_block>, [
		<ore:gemAmber>,<ore:gemAmber>,<ore:gemAmber>,<ore:gemAmber>,<ore:gemAmber>,
		<ore:gemAmber>,<ore:gemAmber>,<ore:gemAmber>,<ore:gemAmber>
	]);

# Amber Gem
	recipes.removeByRecipeName("biomesoplenty:amber");
	recipes.removeByRecipeName("thaumcraft:amberblocktoamber");
	recipes.addShapeless("Amber Gem", <thaumcraft:amber> * 9, [<ore:blockAmber>]);

# Amber Bricks
	recipes.remove(<thaumcraft:amber_brick>);
	recipes.addShapeless("Thaumcraft Amber Brick", 
	<thaumcraft:amber_brick> * 4, 
	[<thaumcraft:amber_block>,<thaumcraft:amber_block>,<thaumcraft:amber_block>,<thaumcraft:amber_block>]);

# Mundane Amulet
	recipes.remove(<thaumcraft:baubles>);
	recipes.addShaped(<thaumcraft:baubles>, 
	[[null, <ore:bRedString>, null], 
	[<ore:bRedString>, null, <ore:bRedString>], 
	[null, <ore:ingotBrass>, null]]);

# Mundane Ring
	recipes.remove(<thaumcraft:baubles:1>);
	recipes.addShaped(<thaumcraft:baubles:1>, 
	[[<ore:ingotGold>, <ore:ingotBrass>, <ore:ingotGold>], 
	[<ore:ingotBrass>, <ore:clusterGold>, <ore:ingotBrass>], 
	[<ore:ingotGold>, <ore:ingotBrass>, <ore:ingotGold>]]);

# Fancy Amulet
	recipes.remove(<thaumcraft:baubles:4>);
	recipes.addShaped(<thaumcraft:baubles:4>, 
	[[null, <botania:spellcloth>.anyDamage(), null], 
	[<botania:spellcloth>.anyDamage(), <ore:clusterGold>, <botania:spellcloth>.anyDamage()], 
	[<ore:gemEmerald>, <thaumcraft:baubles>, <ore:gemEmerald>]]);

# Fancy Ring
	recipes.remove(<thaumcraft:baubles:5>);
	recipes.addShaped(<thaumcraft:baubles:5>, 
	[[<ore:ingotGold>, <ore:gemEmerald>, <ore:ingotGold>], 
	[<ore:ingotGold>, <thaumcraft:baubles:1>, <ore:ingotGold>], 
	[<ore:ingotGold>, <ore:blockGold>, <ore:ingotGold>]]);

# Fancy Belt
	recipes.remove(<thaumcraft:baubles:6>);
	recipes.addShaped(<thaumcraft:baubles:6>,
	[[<ore:leather>, <ore:leather>, <ore:leather>], 
	[<ore:leather>, <ore:clusterCopper>, <ore:leather>], 
	[<ore:gemEmerald>, <thaumcraft:baubles:2>, <ore:gemEmerald>]]);
	
# Golemancer's Bell
	recipes.remove(<thaumcraft:golem_bell>);
	recipes.addShapedMirrored(<thaumcraft:golem_bell>, 
	[[null, <astralsorcery:itemrockcrystalsimple>.anyDamage(), <astralsorcery:itemrockcrystalsimple>.anyDamage()],
	[null, <astralsorcery:itemrockcrystalsimple>.anyDamage(), <astralsorcery:itemrockcrystalsimple>.anyDamage()], 
	[<ore:stickTreatedWood>, null, null]]);

# Salis Mundis visible recipe (original is hidden in JEI)
craft.make(<thaumcraft:salis_mundus>, ["DEFCAB"], {
	A: <ore:itemFlint>.reuse(),
	B: <minecraft:bowl>.reuse(),
	C: <ore:dustRedstone>,
	D: <thaumcraft:crystal_essence:*>.marked("g0"),
	E: <thaumcraft:crystal_essence:*>.marked("g1"),
	F: <thaumcraft:crystal_essence:*>.marked("g2"),
	}, function(out, ins, cInfo) {
    for i in 0 to 2 {
      for j in (i+1) to 3 {
        if (ins["g"~i] has ins["g"~j]) {
          return null; # We found duplicate, return nothing
        }
      }
    }
    return out;
  }, true /* True for shapeless */);


# Override aspects
<rats:rat_diamond>.setAspects(<aspect:desiderium>*4, <aspect:vitreus>*4, <aspect:rattus>*4);
<forestry:candle>.setAspects(<aspect:lux>*20, <aspect:herba>*5, <aspect:aer>*5);
<forestry:stump>.setAspects(<aspect:lux>*20, <aspect:herba>*5, <aspect:aer>*5);
<forestry:beeswax>.setAspects(<aspect:lux>*5, <aspect:aer>*2);
<extrautils2:compressedcobblestone:0>.setAspects(<aspect:terra>*45, <aspect:perditio>*9);
<extrautils2:compressedcobblestone:1>.setAspects(<aspect:terra>*405, <aspect:perditio>*81);
<extrautils2:compressedcobblestone:2>.setAspects(<aspect:terra>*500, <aspect:perditio>*500);
<biomesoplenty:hard_ice>.setAspects(<aspect:gelum>*21);

# Tallow harder
mods.thaumcraft.Crucible.removeRecipe(<thaumcraft:tallow>);
scripts.wrap.thaumcraft.Crucible.registerRecipe("Tallow from rotten flesh", "HEDGEALCHEMY@1", <thaumcraft:tallow>,   <minecraft:rotten_flesh>, [<aspect:ignis>]);
scripts.wrap.thaumcraft.Crucible.registerRecipe("Tallow from tallow",       "HEDGEALCHEMY@1", <thaumcraft:tallow>*2, <quark:tallow>, [<aspect:ignis>*2]);
scripts.wrap.thaumcraft.Crucible.registerRecipe("Tallow from blubber",      "HEDGEALCHEMY@1", <thaumcraft:tallow>*8, utils.tryCatch('betteranimalsplus:blubber', <animania:raw_prime_pork>), [<aspect:ignis>*4]);

# Conflicts
utils.rh(<thaumcraft:nugget:1>);

# Primordial Pearl alt (for some people who dont want to close rifts)
scripts.wrap.astralsorcery.Altar.addConstellationAltarRecipe(
	'Primordial Pearl alt',	<thaumcraft:primordial_pearl:7>, 1500, 250, scripts.craft.grid.Grid([
	"TVT"+
	"CSC"+
	"TVT"+
	"EEEE"+
	"♦♦♦♦◊◊◊◊"], {
  "C": <thaumcraft:causality_collapser>,    # Causality Collapser
  "S": <ore:runeSlothB>,                    # Rune of Sloth
  "T": <thaumcraft:taint_log>,              # Taintwood Log
  "E": <contenttweaker:empowered_phosphor>, # Empowered Phosphor
  "V": <thaumcraft:void_seed>,              # Void Seed
  "♦": <ore:gemTopaz>,                      # Topaz
  "◊": <ore:gemTanzanite>,                  # Tanzanite
	}).shapeless()
);


// ---------------------------
// No-exploration recipe
for aspect, ingr in {
  aer     : <minecraft:feather>,
  terra   : <minecraft:mossy_cobblestone>,
  ignis   : <rustic:chili_pepper>,
  aqua    : <minecraft:potion>.withTag({Potion: "minecraft:water"}),
  ordo    : <advancedrocketry:misc:1>,
  perditio: <minecraft:gunpowder>,
} as IItemStack[string] {
  mods.rustic.Condenser.addRecipe(<thaumcraft:crystal_essence>.withTag({Aspects: [{amount: 1, key: aspect}]}), <thaumcraft:nugget:9>, ingr);
}
import crafttweaker.item.IIngredient;
import crafttweaker.item.IItemStack;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.oredict.IOreDict;
import crafttweaker.oredict.IOreDictEntry;
import crafttweaker.liquid.ILiquidStack;
import crafttweaker.data.IData;
import mods.mekanism.MekanismHelper.getGas as getGas;

import scripts.processUtils.I;
import scripts.processUtils.isNotException;
import scripts.processUtils.isStrict;
import scripts.processUtils.arrN_item;
import scripts.processUtils.arrN_ingr;
import scripts.processUtils.arrN_liq;
import scripts.processUtils.arrN_float;
import scripts.processUtils.defaultItem0;
import scripts.processUtils.defaultChance0;
import scripts.processUtils.defaultChance0_int;
import scripts.processUtils.defaultChanceN;
import scripts.processUtils.warning;
import scripts.processUtils.info;
import scripts.processUtils.avdRockXmlRecipe;
import scripts.processUtils.xmlRecipe;


#priority 51

# ######################################################################
#
# All machines works in one function
#
# ######################################################################

static recipeCount as int = 0 as int;

# Picks one machine to inject recipe in it
# Function receive all possible combinations of input and outputs of one machine
# Any argument can be null except machine name
# Returns name of machine if recipe was added. If not, returns empty string
function workEx(machineNameAnyCase as string, exceptions as string, 
  inputItems as IIngredient[], inputLiquids as ILiquidStack[],
  outputItems as IItemStack[], outputLiquids as ILiquidStack[],
  extra as IItemStack[], extraChance as float[], options as IData) as string {

  # Prepare machine name
  val machineName = machineNameAnyCase.toLowerCase();
  
  # Machine is exception -> exit function
  if (!isNotException(exceptions, machineName)) { return ""; }

  # Strict indicates that old recipe should be removed first
  val strict as bool = isStrict(exceptions, machineName);

  #------------
  # Inputs
  #------------
  val inputIngr0           = arrN_ingr(inputItems, 0);
  val haveItemInput        = !isNull(inputIngr0);
  val inputIsSingle        = haveItemInput && inputItems.length == 1;

  val inputLiquid0         = arrN_liq(inputLiquids, 0);
  val haveLiquidInput      = !isNull(inputLiquid0);
  val inputLiquidIsSingle  = haveLiquidInput && inputLiquids.length == 1;

  #------------
  # Outputs
  #------------
  val outputItem0          = arrN_item(outputItems, 0);
  val haveItemOutput       = !isNull(outputItem0);
  val outputIsSingle       = haveItemOutput && outputItems.length == 1;

  val outputLiquid0        = arrN_liq(outputLiquids, 0);
  val haveLiquidOutput     = !isNull(outputLiquid0);
  val outputLiquidIsSingle = haveLiquidOutput && outputLiquids.length == 1;

  val haveGasOutput        = !isNull(D(options, "gasOutput"));
  val outputGasAmount      = Dd(options, "gasOutputAmount", {d:600}).asInt();
  val outputGas            = haveGasOutput ? getGas(options.gasOutput.asString()) * outputGasAmount : null;

  #------------
  # Extra
  #------------
  val extra0               = arrN_item(extra, 0);
  val haveExtra            = !isNull(extra0);
  val outputItem0orExtra0  = haveItemOutput ? outputItem0 : extra0;

  #------------
  # Relations
  #------------
  val item_to_item = haveItemInput && haveItemOutput;

  #------------
  # List Length
  #------------
  val lenInItem  = haveItemInput    ? inputItems.length    : 0;
  val lenInLiqs  = haveLiquidInput  ? inputLiquids.length  : 0;
  val lenOutItem = haveItemOutput   ? outputItems.length   : 0;
  val lenOutLiqs = haveLiquidOutput ? outputLiquids.length : 0;

  #------------
  # Combined
  #------------
  var combinedOutput as IItemStack[] = null;
  var combinedChances as float[] = null;
  if (haveItemOutput) { for i in 0 to outputItems.length {
      if (isNull(combinedOutput)) { combinedOutput = []; combinedChances = []; }
      combinedOutput = combinedOutput + outputItems[i];
      combinedChances = combinedChances + 1.0f;
  }}
  if (haveExtra) { for i in 0 to extra.length {
      if (isNull(combinedOutput)) { combinedOutput = []; combinedChances = []; }
      combinedOutput = combinedOutput + extra[i];
      combinedChances = combinedChances + ((!isNull(extraChance) && extraChance.length > i) ? extraChance[i] : 1.0f);
  }}


  # Machines with one item slot for input and output
  # 📦 → 📦
  if (item_to_item && inputIsSingle && outputIsSingle) {
    
    if (machineName == "blockcutter") {
      # mods.ic2.BlockCutter.addRecipe(IItemStack output, IIngredient input, @Optional int hardness default 0);
      scripts.wrap.ic2.BlockCutter.addRecipe(outputItem0, inputIngr0);
      return machineName;
    }

    if (machineName == "compressor") {
      scripts.wrap.ic2.Compressor.addRecipe(outputItem0, inputIngr0);
      return machineName;
    }

    if (machineName == "macerator") {
      scripts.wrap.ic2.Macerator.addRecipe(outputItem0, inputIngr0);
      return machineName;
    }
    
    if (machineName == "extractor") {
      scripts.wrap.ic2.Extractor.addRecipe(outputItem0, inputIngr0);
      return machineName;
    }

    if (machineName == "grindstone") {
      # mods.astralsorcery.Grindstone.addRecipe(IItemStack input, IItemStack output, float doubleChance);
      if (inputIngr0.amount == 1) {
        for ii in inputIngr0.itemArray {
          scripts.wrap.astralsorcery.Grindstone.addRecipe(ii, outputItem0, defaultChance0(extraChance, 0.0f) / outputItem0.amount);
        }
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but this machine can only work with 1 item as input");
      }
      return machineName;
    }

    if (machineName == "compactor") {
      for ii in inputIngr0.itemArray {
        scripts.wrap.thermalexpansion.Compactor.addPressRecipe(outputItem0, ii, 4000);
      }
      return machineName;
    }

    if (machineName == "pulverizer") {
      # mods.thermalexpansion.Pulverizer.addRecipe(IItemStack output, IItemStack input, int energy, @Optional IItemStack secondaryOutput, @Optional int secondaryChance);
      for ii in inputIngr0.itemArray {
        if (strict) { mods.thermalexpansion.Pulverizer.removeRecipe(ii); }
        if (haveExtra) {
          scripts.wrap.thermalexpansion.Pulverizer.addRecipe(outputItem0, ii, 4000, extra[0], defaultChance0_int(extraChance, 100));
        } else {
          scripts.wrap.thermalexpansion.Pulverizer.addRecipe(outputItem0, ii, 4000);
        }
      }
      return machineName;
    }

    if (machineName == "manufactory") {
      if (strict) { mods.nuclearcraft.manufactory.removeRecipeWithInput([inputIngr0]); }
      mods.nuclearcraft.manufactory.addRecipe(inputIngr0, outputItem0);
      return machineName;
    }

    if (machineName == "pressurizer") {
      mods.nuclearcraft.pressurizer.addRecipe(inputIngr0, outputItem0);
      return machineName;
    }

    if (machineName == "mekenrichment") {
      // # mods.mekanism.enrichment.addRecipe(IIngredient inputStack, IItemStack outputStack);
      scripts.wrap.mekanism.enrichment.addRecipe(inputIngr0, outputItem0);
      return machineName;
    }

    if (machineName == "mekpurification") {
      scripts.wrap.mekanism.purification.addRecipe(inputIngr0, outputItem0);
      return machineName;
    }

    if (machineName == "mekinjection") {
      scripts.wrap.mekanism.chemical_injection.addRecipe(inputIngr0, <gas:hydrogenchloride>, outputItem0);
      return machineName;
    }

    if (machineName == "meksawmill") {
      if (strict) { mods.mekanism.sawmill.removeRecipe(inputIngr0); }
      # mods.mekanism.sawmill.addRecipe(IIngredient inputStack, IItemStack outputStack, @Optional IItemStack bonusOutput, @Optional double bonusChance);
      if (haveExtra) {
        scripts.wrap.mekanism.sawmill.addRecipe(inputIngr0, outputItem0, extra[0], defaultChance0(extraChance, 1.0f) as double);
      } else {
        scripts.wrap.mekanism.sawmill.addRecipe(inputIngr0, outputItem0);
      }
      return machineName;
    }

    if (machineName == "mekcrusher") {
      # mods.mekanism.crusher.addRecipe(IIngredient inputStack, IItemStack outputStack);
      # mods.mekanism.crusher.removeRecipe(IIngredient outputStack, @Optional IIngredient inputStack);
      if (strict) { mods.mekanism.crusher.removeRecipe(outputItem0); }
      scripts.wrap.mekanism.crusher.addRecipe(inputIngr0, outputItem0);
      return machineName;
    }

    if (machineName == "tesawmill") {
      # mods.thermalexpansion.Sawmill.addRecipe(IItemStack output, IItemStack input, int energy, @Optional IItemStack secondaryOutput, @Optional int secondaryChance);
      for ii in inputIngr0.itemArray {
      if (haveExtra) {
        scripts.wrap.thermalexpansion.Sawmill.addRecipe(outputItem0, ii, 1000, extra[0], defaultChance0_int(extraChance, 100));
      } else {
        scripts.wrap.thermalexpansion.Sawmill.addRecipe(outputItem0, ii, 1000);
      }
      }
      return machineName;
    }

    if (machineName == "eu2crusher") {
      # mods.extrautils2.Crusher.add(IItemStack output, IItemStack input, @Optional IItemStack secondaryOutput, @Optional float secondaryChance);

      for ii in inputIngr0.itemArray {
        if (haveExtra) {
          scripts.wrap.extrautils2.Crusher.add(outputItem0, ii, extra[0], extraChance[0]);
        } else {
          scripts.wrap.extrautils2.Crusher.add(outputItem0, ii);
        }
      }
      return machineName;
    }
    
    if (machineName == "aacrusher") {
      if (strict) { mods.actuallyadditions.Crusher.removeRecipe(outputItem0); }
      # mods.actuallyadditions.Crusher.addRecipe(IItemStack output, IItemStack input, @Optional IItemStack outputSecondary, @Optional int outputSecondaryChance);
          
      if (inputIngr0.amount != 1) {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), 
        "received work, but this machine can only work with 1 item as input");
      }

      for ii in inputIngr0.itemArray {
        if (haveExtra) {
          scripts.wrap.actuallyadditions.Crusher.addRecipe(outputItem0, ii, extra[0], defaultChance0_int(extraChance, 100));
        } else {
          scripts.wrap.actuallyadditions.Crusher.addRecipe(outputItem0, ii);
        }
      }
      return machineName;
    }

    if (machineName == "aegrinder") {
      # Grinder.removeRecipe(IItemStack input);
      # Grinder.addRecipe(IItemStack output, IItemStack input, int turns, @Optional IItemStack secondary1Output, @Optional float secondary1Chance, @Optional IItemStack secondary2Output, @Optional float secondary2Chance);

      for ii in inputIngr0.itemArray {
        if (strict) { mods.appliedenergistics2.Grinder.removeRecipe(ii); }
        if (haveExtra) {
          if (extra.length == 1) {
            scripts.wrap.appliedenergistics2.Grinder.addRecipe(outputItem0, ii, 2, extra[0], extraChance[0]);
          }else if (extra.length >= 2) {
            scripts.wrap.appliedenergistics2.Grinder.addRecipe(outputItem0, ii, 2, extra[0], extraChance[0], extra[1], extraChance[1]);
          }
        } else {
          scripts.wrap.appliedenergistics2.Grinder.addRecipe(outputItem0, ii, 2);
        }
      }
      return machineName;
    }

    if (machineName == "metalpress") {
      # mods.immersiveengineering.MetalPress.addRecipe(IItemStack output, IIngredient input, IItemStack mold, int energy, @Optional int inputSize);

      val molds as IItemStack[string] = {
        plate: <immersiveengineering:mold:0>,
        gear:  <immersiveengineering:mold:1>,
        rod:   <immersiveengineering:mold:2>,
        unpack:<immersiveengineering:mold:7>,
      } as IItemStack[string];

      val mold = !isNull(options.mold) ? molds[options.mold.asString()] : null;
      scripts.wrap.immersiveengineering.MetalPress.addRecipe(outputItem0, inputIngr0, !isNull(mold) ? mold : molds.plate, 2000, inputIngr0.amount);
      return machineName;
    }
  } 

  # Machines with ONE item INPUT
  # 📦 → [📦+]
  if (item_to_item && inputIsSingle) {
  
    if (machineName == "thermalcentrifuge") {
      # mods.ic2.ThermalCentrifuge.addRecipe([IItemStack[] outputs, IIngredient input, @Optional int minHeat);
      scripts.wrap.ic2.ThermalCentrifuge.addRecipe(outputItems, inputIngr0);
      return machineName;
    }
  
    if (machineName == "pampresser") {
      # mods.harvestcrafttweaker.HarvestCraftTweaker.addPressing(IIngredient input, IItemStack leftOutput, IItemStack rightOutput);
      if (outputItems.length == 1 && outputItems[0].amount >= 2) {
        val left = outputItems[0].amount / 2;
        val right= outputItems[0].amount - left;
        mods.harvestcrafttweaker.HarvestCraftTweaker.addPressing(inputIngr0, outputItems[0] * left, outputItems[0] * right);
      } else if (outputItems.length == 2) {
        mods.harvestcrafttweaker.HarvestCraftTweaker.addPressing(inputIngr0, outputItems[0], outputItems[1]);
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but this output items cant be separated for two slots");
      }
      return machineName;
    }
  
    if (machineName == "pamgrinder") {
      # mods.harvestcrafttweaker.HarvestCraftTweaker.addGrinding(IIngredient input, IItemStack leftOutput, IItemStack rightOutput);
      if (outputItems.length == 1 && outputItems[0].amount >= 2) {
        val left = outputItems[0].amount / 2;
        val right= outputItems[0].amount - left;
        mods.harvestcrafttweaker.HarvestCraftTweaker.addGrinding(inputIngr0, outputItems[0] * left, outputItems[0] * right);
      } else if (outputItems.length == 2) {
        mods.harvestcrafttweaker.HarvestCraftTweaker.addGrinding(inputIngr0, outputItems[0], outputItems[1]);
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but this output items cant be separated for two slots");
      }
      return machineName;
    }
  
    if (machineName == "pamfilter") {
      # mods.harvestcrafttweaker.HarvestCraftTweaker.addWaterFilter(IIngredient input, IItemStack leftOutput, IItemStack rightOutput);
      if (outputItems.length == 1 && outputItems[0].amount >= 2) {
        val left = outputItems[0].amount / 2;
        val right= outputItems[0].amount - left;
        mods.harvestcrafttweaker.HarvestCraftTweaker.addWaterFilter(inputIngr0, outputItems[0] * left, outputItems[0] * right);
      } else if (outputItems.length == 2) {
        mods.harvestcrafttweaker.HarvestCraftTweaker.addWaterFilter(inputIngr0, outputItems[0], outputItems[1]);
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but this output items cant be separated for two slots");
      }
      return machineName;
    }
  }
  
  # Machines with ONE item INPUT and unknown output
  # 📦 → ?
  if (inputIsSingle) {
  
    if (machineName == "rockcrusher") {
      # mods.nuclearcraft.rock_crusher.addRecipe([itemInput, itemOutput1, itemOutput2, itemOutput3, @Optional double timeMultiplier, @Optional double powerMultiplier, @Optional double processRadiation]);
      mods.nuclearcraft.rock_crusher.addRecipe([inputIngr0, 
        arrN_item(combinedOutput, 0), (combinedChances[0] * 100) as int,
        arrN_item(combinedOutput, 1), (combinedChances[1] * 100) as int,
        arrN_item(combinedOutput, 2), (combinedChances[2] * 100) as int,
        2.0d, 1.5d]);
      return machineName;
    }
  
    if (machineName == "crushingblock") {
      # addCrushingBlockRecipe(IItemStack input, IItemStack[] outputs, double[] probs)

      if (inputIngr0.amount != 1) {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), 
        "received work, but this machine can only work with 1 item as input");
      }

      # Summ of chances should be equal 1, so we compute it
      var chancesSumm = 0.0f;
      var normalizedChances = [] as float[];
      for ch in combinedChances { chancesSumm += ch; }
      for ch in combinedChances { normalizedChances = normalizedChances + (ch / chancesSumm); }
      for ii in inputIngr0.itemArray {
        mods.mechanics.addCrushingBlockRecipe(ii, combinedOutput, normalizedChances);
      }
      return machineName;
    }
    
    if (machineName == "squeezer") {
      # Squeezer.addRecipe(IItemStack inputStack, 
      #   @Optional IItemStack outputStack1, @Optional float outputStackChance1,
      #   @Optional IItemStack outputStack2, @Optional float outputStackChance2,
      #   @Optional IItemStack outputStack3, @Optional float outputStackChance3,
      #   @Optional ILiquidStack outputFluid);
      for ii in inputIngr0.itemArray {
        scripts.wrap.integrateddynamics.Squeezer.addRecipe(ii, 
          arrN_item(outputItems, 0), arrN_float(extraChance, 0), 
          arrN_item(outputItems, 1), arrN_float(extraChance, 1), 
          arrN_item(outputItems, 2), arrN_float(extraChance, 2), 
          outputLiquid0);
      }
      return machineName;
    }

    if (machineName == "mechanicalsqueezer") {
      # MechanicalSqueezer.addRecipe(IItemStack inputStack, 
      #   @Optional IItemStack outputStack1, @Optional float outputStackChance1,
      #   @Optional IItemStack outputStack2, @Optional float outputStackChance2,
      #   @Optional IItemStack outputStack3, @Optional float outputStackChance3,
      #   @Optional ILiquidStack outputFluid, @Optional(10) int duration);
      for ii in inputIngr0.itemArray {
        scripts.wrap.integrateddynamics.MechanicalSqueezer.addRecipe(ii, 
          arrN_item(outputItems, 0), arrN_float(extraChance, 0), 
          arrN_item(outputItems, 1), arrN_float(extraChance, 1), 
          arrN_item(outputItems, 2), arrN_float(extraChance, 2), 
          outputLiquid0);
      }
      return machineName;
    }

    if (machineName == "tecentrifuge") {
      #mods.thermalexpansion.Centrifuge.addRecipe(WeightedItemStack[] outputs, IItemStack input, ILiquidStack fluid, int energy);
      if (!isNull(combinedOutput)  && combinedOutput.length  > 0 &&
          combinedChances.length >= combinedOutput.length) {
        
        # Calculate chanced output from combined
        var chancedCombined = [] as WeightedItemStack[];
        for i in 0 to combinedOutput.length {
          chancedCombined = chancedCombined + combinedOutput[i] % ((combinedChances[i] * 100) as int);
        }

        for ii in inputIngr0.itemArray {
          scripts.wrap.thermalexpansion.Centrifuge.addRecipe(chancedCombined, ii, outputLiquid0, 2000);
        }
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but this machine MUST have item output");
      }
      return machineName;
    }

    if (machineName == "sagmill") {
      if (inputIngr0.amount != 1) {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), 
        "received work, but this machine can only work with 1 item as input");
      }
      
      if (combinedOutput.length > 0 && combinedChances.length >= combinedOutput.length) {
        scripts.wrap.enderio.SagMill.addRecipe(combinedOutput, combinedChances, inputIngr0);
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but no output or extra was found");
      }
      return machineName;
    }

    if (machineName == "iecrusher") {
      # mods.immersiveengineering.Crusher.removeRecipe(IItemstack output);
      if (strict) { mods.immersiveengineering.Crusher.removeRecipe(outputItem0); }
      # mods.immersiveengineering.Crusher.addRecipe(IItemStack output, IIngredient input, int energy, @Optional IItemStack secondaryOutput, @Optional double secondaryChance);
      if (haveExtra) {
        scripts.wrap.immersiveengineering.Crusher.addRecipe(outputItem0, inputIngr0, 2048, extra[0], extraChance[0]);
      } else {
        scripts.wrap.immersiveengineering.Crusher.addRecipe(outputItem0, inputIngr0, 2048);
      }
      return machineName;
    }

  }

  # Machines with ONE item output
  # [📦+] → 📦
  if (item_to_item && outputIsSingle) {

    if (machineName == "shapeless") {
      if (inputItems.length <= 9) {
        if (strict) {
          if (inputItems.length <= 3) { recipes.removeShaped(<*>, [inputItems]); }
          recipes.removeShapeless(<*>, inputItems);
        }
        recipes.addShapeless("shapeless " ~ getRecipeName(inputIngr0.itemArray[0], outputItem0), outputItem0, inputItems);
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but input more than 9");
      }
      return machineName;
    }

    if (machineName == "arcfurnance") {
      # mods.immersiveengineering.ArcFurnace.addRecipe(IItemStack output, IIngredient input, IItemStack slag, int time, int energyPerTick, @Optional IIngredient[] additives, @Optional String specialRecipeType);
      if (inputItems.length > 1) {
        # Reduce all ingredients to additives
        var additives = [] as IIngredient[];
        for i in 1 to inputItems.length {
          additives = additives + inputItems[i];
        }
        scripts.wrap.immersiveengineering.ArcFurnace.addRecipe(outputItem0, inputIngr0, defaultItem0(extra, I("immersiveengineering:material",7)), 200, 512, additives, "Alloying");
      } else {
        scripts.wrap.immersiveengineering.ArcFurnace.addRecipe(outputItem0, inputIngr0, defaultItem0(extra, I("immersiveengineering:material",7)), 200, 512);
      }
      return machineName;
    }

    if (machineName == "alloysmelter") {
      if (strict) { mods.enderio.AlloySmelter.removeRecipe(outputItem0); }
      scripts.wrap.enderio.AlloySmelter.addRecipe(outputItem0, inputItems, 2000);
      return machineName;
    }

    if (machineName == "kiln") {
      if (strict) { mods.immersiveengineering.AlloySmelter.removeRecipe(outputItem0); }
      if (inputItems.length == 2) {
        scripts.wrap.immersiveengineering.AlloySmelter.addRecipe(outputItem0, inputItems[0], inputItems[1], 400);
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but number of inputs != 2");
      }

      return machineName;
    }

    if (machineName == "alloyfurnace") {
      if (inputItems.length == 2) {
        mods.nuclearcraft.alloy_furnace.addRecipe(inputItems[0], inputItems[1], outputItem0);
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but number of inputs != 2");
      }
      return machineName;
    }

    if (machineName == "induction") {
      # mods.thermalexpansion.InductionSmelter.addRecipe(IItemStack primaryOutput, IItemStack primaryInput, IItemStack secondaryInput, int energy, @Optional IItemStack secondaryOutput, @Optional int secondaryChance);

      val additions as IItemStack[] = [
        <minecraft:sand>, I("thermalfoundation:material",864), I("thermalfoundation:material",865), I("thermalfoundation:material",866)
      ] as IItemStack[];

      if (inputItems.length == 1) {
        # Only one input - add automatically scalled output based on catalyst
        for ii in inputIngr0.itemArray {
          scripts.wrap.thermalexpansion.InductionSmelter.addRecipe(outputItem0, ii, additions[0], 4000, haveExtra ? extra[0] : additions[1], defaultChance0_int(extraChance, 10));
          scripts.wrap.thermalexpansion.InductionSmelter.addRecipe(outputItem0, ii, additions[2], 6000, haveExtra ? extra[0] : additions[1], defaultChance0_int(extraChance, 10));
          scripts.wrap.thermalexpansion.InductionSmelter.addRecipe(outputItem0, ii, additions[3], 8000, haveExtra ? extra[0] : additions[2], defaultChance0_int(extraChance, 10));
        }
      } else if (inputItems.length == 2) {
        for ii in inputItems[0].itemArray {
          for jj in inputItems[1].itemArray {
            scripts.wrap.thermalexpansion.InductionSmelter.addRecipe(outputItem0, ii, jj, 4000, haveExtra ? extra[0] : additions[1], defaultChance0_int(extraChance, 15));
          }
        }
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but number of inputs 3 or more");
      }
      return machineName;
    }

    if (machineName == "insolator") {
      #mods.thermalexpansion.Insolator.addRecipe(IItemStack primaryOutput, IItemStack primaryInput, IItemStack secondaryInput, int energy, @Optional IItemStack secondaryOutput, @Optional int secondaryChance);

      val energy = (!isNull(options) && !isNull(options.energy)) ? options.energy as int : 4800;

      if (inputItems.length == 2) {
        for ii in inputItems[0].itemArray {
          for jj in inputItems[1].itemArray {
            scripts.wrap.thermalexpansion.Insolator.addRecipe(outputItem0, ii, jj, energy, extra0, defaultChance0_int(extraChance, 100));
          }
        }
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but number of inputs != 2");
      }
      return machineName;
    }
  }

  # Machines with any item s input and output
  # [📦+] → [📦+]
  if (item_to_item) {

    if (machineName == "advrockarc") {
      # Log recipes to manual add in XML file
      avdRockXmlRecipe("ElectricArcFurnace", inputItems, null, outputItems, null);
      return machineName;
    }

    if (machineName == "advrockcutter") {
      # Log recipes to manual add in XML file
      avdRockXmlRecipe("CuttingMachine", inputItems, null, outputItems, null);
      return machineName;
    }

    if (machineName == "hydroponics") {
      val builder = mods.modularmachinery.RecipeBuilder
        .newBuilder("hydroponics_" ~ getItemName(outputItem0) ~"-"~recipeCount, "hydroponics", 40)
        .addEnergyPerTickInput(200000);

      for ins in inputItems { builder.addItemInput(ins.itemArray[0]); }
      for out in combinedOutput { builder.addItemOutput(out); }
      if (haveLiquidInput) { builder.addFluidInput(inputLiquid0); }

      builder.build();
      recipeCount += 1;
      return machineName;
    }

    if (machineName == "starlightinfuser") {
      # mods.astralsorcery.StarlightInfusion.addInfusion(IItemStack input, IItemStack output, boolean consumeMultiple, float consumptionChance, int craftingTickTime);
      
      if (inputIngr0.amount != 1) {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), 
        "received work, but this machine can only work with 1 item as input");
      }

      if (inputItems.length == 1 && outputItems.length == 1) {
        for ii in inputIngr0.itemArray {
          scripts.wrap.astralsorcery.StarlightInfusion.addInfusion(ii, outputItem0, false, 0.7, 60);
        }
      } else {
        return info(machineNameAnyCase, getItemName(inputIngr0.itemArray[0]), "received work, but number of inputs or outputs != 1");
      }
      return machineName;
    }

  }

  # ONE item to one liquid
  # 📦 → 💧
  if (inputIsSingle && outputLiquidIsSingle) {

    if (machineName == "crushingtub") {
      # mods.rustic.CrushingTub.addRecipe(output as ILiquidStack, byproduct as IItemStack, input as IItemStack);
      for ii in inputIngr0.itemArray {
        mods.rustic.CrushingTub.addRecipe(outputLiquid0, outputItem0orExtra0, ii);
      }
      return machineName;
    }

    if (machineName == "industrialsqueezer") {
      # mods.immersiveengineering.Squeezer.addRecipe(IItemStack output, ILiquidStack fluid, IIngredient input, int energy);
      scripts.wrap.immersiveengineering.Squeezer.addRecipe(outputItem0, outputLiquid0, inputIngr0, 2048);
      return machineName;
    }

    if (machineName == "crucible") {
      # mods.thermalexpansion.Crucible.addRecipe(ILiquidStack output, IItemStack input, int energy);
      for ii in inputIngr0.itemArray {
        scripts.wrap.thermalexpansion.Crucible.addRecipe(outputLiquid0, ii, 2800);
      }
      return machineName;
    }

    if (machineName == "smeltery") {
      # mods.tconstruct.Melting.addRecipe(ILiquidStack output, IIngredient input, @Optional int temp);
      scripts.wrap.tconstruct.Melting.addRecipe(outputLiquid0, inputIngr0);
      return machineName;
    }

    if (machineName == "melter") {
      mods.nuclearcraft.melter.addRecipe(inputIngr0, outputLiquid0);
      return machineName;
    }

    if (machineName == "fluidextractor") {
      # mods.nuclearcraft.extractor.addRecipe([itemInput, itemOutput, fluidOutput, @Optional double timeMultiplier, @Optional double powerMultiplier, @Optional double processRadiation]);
      mods.nuclearcraft.extractor.addRecipe(inputIngr0, outputItem0, outputLiquid0);
      return machineName;
    }
  }

  # ONE item to one liquid
  # 💧 → 📦
  if (inputLiquidIsSingle && outputIsSingle) {

    if (machineName == "evaporatingbasin") {
      mods.rustic.EvaporatingBasin.addRecipe(outputItem0, inputLiquid0);
      return machineName;
    }

  }

  # ONE item + ONE liquid -> item
  # 📦💧 → 📦
  if (inputIsSingle && inputLiquidIsSingle && outputIsSingle) {

    if (machineName == "casting") { 
      scripts.wrap.tconstruct.Casting.addTableRecipe(outputItem0, inputIngr0, inputLiquid0, inputLiquid0.amount, true);
      return machineName;
    }

    if (machineName == "ncinfuser") { 
      mods.nuclearcraft.infuser.addRecipe(inputIngr0, inputLiquid0, outputItem0);
      return machineName;
    }

    if (machineName == "transposer") { 
      //mods.thermalexpansion.Transposer.addFillRecipe(IItemStack output, IItemStack input, ILiquidStack fluid, int energy);
      for ii in inputIngr0.itemArray {
        scripts.wrap.thermalexpansion.Transposer.addFillRecipe(outputItem0, ii, inputLiquid0, 2000);
      }
      return machineName;
    }

  }

  # ONE item + ONE liquid -> ONE liquid
  # 📦💧 → 💧
  if (inputIsSingle && inputLiquidIsSingle && outputLiquidIsSingle) {

    if (machineName == "canner") {
      # mods.ic2.Canner.addEnrichRecipe(ILiquidStack output, ILiquidStack input, IIngredient additive);
      scripts.wrap.ic2.Canner.addEnrichRecipe(outputLiquid0, inputLiquid0, inputIngr0);
      return machineName;
    }
    
    if (machineName == "fluidenricher") {
      # mods.nuclearcraft.dissolver.addRecipe([itemInput, fluidInput, fluidOutput, @Optional double timeMultiplier, @Optional double powerMultiplier, @Optional double processRadiation]);
      mods.nuclearcraft.dissolver.addRecipe(inputIngr0, inputLiquid0, outputLiquid0);
      return machineName;
    }

  }

  # ONE liquid -> 1+ liquid
  # 💧 → [💧+]
  if (inputLiquidIsSingle && haveLiquidOutput) {
    
    if (machineName == "ic2electrolyzer") {
      # mods.ic2.Electrolyzer.addRecipe(ILiquidStack[] outputs, ILiquidStack input, int power, @Optional int time);
      # mods.ic2.Electrolyzer.addRecipe(outputLiquids, inputLiquid0, 40);
      return warning(machineNameAnyCase, inputLiquid0.name,
      "process.work: IC2 Tweaker have bug for adding Electrolyzer recipe. Would be fixed if PR would merged");
      return machineName;
    }
    
    if (machineName == "ncelectrolyzer") {
      # mods.nuclearcraft.electrolyser.addRecipe([fluidInput, fluidOutput1, fluidOutput2, fluidOutput3, fluidOutput4, @Optional double timeMultiplier, @Optional double powerMultiplier, @Optional double processRadiation]);
      mods.nuclearcraft.electrolyser.addRecipe(inputLiquid0, arrN_liq(outputLiquids, 0), arrN_liq(outputLiquids, 1), arrN_liq(outputLiquids, 2), arrN_liq(outputLiquids, 3), 40);
      return machineName;
    }
  }

  # 1+ liquid -> 1+ liquid
  # [💧+] → [💧+]
  if (haveLiquidInput && haveLiquidOutput) {

    if (machineName == "advrockelectrolyzer") {
      # Log recipes to manual add in XML file
      avdRockXmlRecipe("Electrolyser", null, inputLiquids, null, outputLiquids);
      return machineName;
    }
  }

  # ONE liquid + 1+ item -> ONE liquid
  # 💧[📦+] -> 💧
  if (inputLiquidIsSingle && outputLiquidIsSingle && haveItemInput) {

    if (machineName == "highoven") {
      if (inputItems.length <= 3) {
        # Using input items array as Oxidiser, Reducer and Purifier
        var in0 = inputIngr0;
        var in1 = arrN_ingr(inputItems, 1);
        var in2 = arrN_ingr(inputItems, 2);
        
        # Uses extra chance array last element as temperature
        # Default temperature is 500
        var lastIndex as int = isNull(extraChance) ? 999999 : (extraChance.length - 1);
        var temp as int = arrN_float(extraChance, lastIndex) as int;
        if (temp <= 0) { temp = 500; }

        # Computing chance of consuming additionals
        # Last chance should determine temperature
        #   if no chance provided, its 100%
        var v = (arrN_float(extraChance, 0) * 100) as int;
        val exChLen = !isNull(extraChance) ? extraChance.length : 0;
        var ch0 as int = (exChLen > 1 && v > 0) ? v : 100;

        v = (arrN_float(extraChance, 1) * 100) as int;
        var ch1 as int = (exChLen > 2 && v > 0) ? v : 100;

        v = (arrN_float(extraChance, 2) * 100) as int;
        var ch2 as int = (exChLen > 3 && v > 0) ? v : 100;

        # Create recipe
        var builder = mods.tcomplement.highoven.HighOven.newMixRecipe(outputLiquid0, inputLiquid0, temp);
        
        # Add additionals
        if (!isNull(in0)) { builder.addOxidizer(in0, ch0); }
        if (!isNull(in1)) { builder.addReducer (in1, ch1); }
        if (!isNull(in2)) { builder.addPurifier(in2, ch2); }
        builder.register();
        
        return machineName;
      } else {
        return info(machineNameAnyCase, inputLiquid0.name, "received work, but amount of inputs > 3");
      }
    }

    if (machineName == "vat") {
      if (inputItems.length <= 2) {
        var s = "<recipe name=\"" ~ outputLiquid0.displayName ~ "\" required=\"true\"><fermenting energy=\"10000\">\n";
        for inIngr in inputItems {
          s = s ~ "  <inputgroup>\n";
          for ii in inIngr.itemArray {
            s = s ~ "    <input name=\"" ~ ii.commandString.replaceAll("[<>]", "") ~ "\" multiplier=\"1.0\" />\n";
          }
          s = s ~ "  </inputgroup>\n";
        }
        s = s ~ "    <inputfluid name=\"" ~ inputLiquid0.name ~ "\" multiplier=\"" ~ (outputLiquid0.amount as float) / 1000 ~ "\" />\n";
        s = s ~ "    <outputfluid name=\"" ~ outputLiquid0.name ~ "\" /></fermenting></recipe>";

        xmlRecipe("./config/enderio/recipes/user/user_recipes.xml", s);
        # mods.enderio.Vat.addRecipe(ILiquidStack output, ILiquidStack input, IIngredient[] slot1Solids, float[] slot1Mults, IIngredient[] slot2Solids, float[] slot2Mults, @Optional int energyCost);
        # mods.enderio.Vat.addRecipe(outputLiquid0, inputLiquid0, [arrN_item(inputItems, 0)], [1.0f], [arrN_item(inputItems, 1)], [1.0f], 5000);
        return machineName;
      } else {
        return info(machineNameAnyCase, inputLiquid0.name, "received work, but amount of inputs > 2");
      }
    }
  }

  # Complicated input & output
  # 📦|💧 → [📦+]|💧
  if ((inputIsSingle || inputLiquidIsSingle) && (haveItemOutput || outputLiquidIsSingle)) {

    if (machineName == "dryingbasin") {
      # DryingBasin.addRecipe(@Optional IItemStack inputStack, @Optional ILiquidStack inputFluid, @Optional IItemStack outputStack, @Optional ILiquidStack outputFluid, @Optional(10) int duration);
      if (inputIsSingle) {
        for ii in inputItems[0].itemArray {
          scripts.wrap.integrateddynamics.DryingBasin.addRecipe(ii, inputLiquid0, outputItem0, outputLiquid0, 80);
        }
      } else {
        scripts.wrap.integrateddynamics.DryingBasin.addRecipe(null, inputLiquid0, outputItem0, outputLiquid0, 80);
      }
      return machineName;
    }

    if (machineName == "mechanicaldryingbasin") {
      # MechanicalDryingBasin.addRecipe(@Optional IItemStack inputStack, @Optional ILiquidStack inputFluid, @Optional IItemStack outputStack, @Optional ILiquidStack outputFluid, @Optional(10) int duration);
      if (inputIsSingle) {
        for ii in inputItems[0].itemArray {
          scripts.wrap.integrateddynamics.MechanicalDryingBasin.addRecipe(ii, inputLiquid0, outputItem0, outputLiquid0, 80);
        }
      } else {
        scripts.wrap.integrateddynamics.MechanicalDryingBasin.addRecipe(null, inputLiquid0, outputItem0, outputLiquid0, 80);
      }
      return machineName;
    }
  }

  # Complicated input
  # [📦+]|[💧+] → [📦+]|💧
  if ((haveItemInput || haveLiquidInput) && (haveItemOutput || outputLiquidIsSingle)) {

    if (machineName == "chemicalreactor") {
      if (lenInItem <= 4 && lenInLiqs <= 2 && lenOutItem <= 4 & lenOutLiqs <= 1) {
        avdRockXmlRecipe("ChemicalReactor", inputItems, inputLiquids, outputItems, outputLiquids);
        return machineName;
      } else {
        return info(machineNameAnyCase, inputLiquid0.name, "received work, but input and output amounts can't fit in machine");
      }
    }

    if (machineName == "forestrysqueezer") {
      #mods.forestry.Squeezer.addRecipe(ILiquidStack fluidOutput, IItemStack[] ingredients, int timePerItem, @Optional WeightedItemStack itemOutput);
      var inputItemStacks = [] as IItemStack[];
      for inIngr in inputItems {
        inputItemStacks = inputItemStacks + inIngr.itemArray[0];
      }
      val wOut as WeightedItemStack = !isNull(outputItem0) ? outputItem0 % defaultChance0_int(extraChance, 20) : null;
      scripts.wrap.forestry.Squeezer.addRecipe(outputLiquid0, inputItemStacks, 20, wOut);
      return machineName;
    }
  }

  # ONE item to one gas
  # 📦 → 🟡
  if (inputIsSingle && haveGasOutput) {
    if (machineName == "mekdissolution") {
      scripts.wrap.mekanism.chemical_dissolution.addRecipe(inputIngr0, outputGas);
      return machineName;
    }
  }


  return warning(machineNameAnyCase,
    !isNull(inputIngr0)   ? getItemName(inputIngr0.itemArray[0]) : (
    !isNull(inputLiquid0) ? ("💧" ~ inputLiquid0.name) : "[unknown input]"),
    "received work, but machine with this name can't be found");
}

function work(machineNameAnyCase as string[], exceptions as string, 
    inputItems as IIngredient[], inputLiquids as ILiquidStack[],
    outputItems as IItemStack[], outputLiquids as ILiquidStack[],
    extra as IItemStack[], extraChance as float[]) as string {

  for machine in machineNameAnyCase {
    workEx(machine, exceptions, inputItems, inputLiquids, outputItems, outputLiquids, extra, extraChance, null);
  }
}
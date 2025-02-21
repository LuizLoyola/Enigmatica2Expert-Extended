## Minecraft load time benchmark


---

<p align="center" style="font-size:160%;">
MC total load time:<br>
596.88 sec
<br>
<sup><sub>(
9:56 min
)</sub></sup>
</p>

<br>


<p align="center">
<img src="https://quickchart.io/chart?w=400&h=30&c={
  type: 'horizontalBar',
  data: {
    datasets: [
      {label:      'MODS:', data: [363.81]},
      {label: 'FML stuff:', data: [233.07]}
    ]
  },
  options: {
    scales: {
      xAxes: [{display: false,stacked: true}],
      yAxes: [{display: false,stacked: true}],
    },
    elements: {rectangle: {borderWidth: 2}},
    legend: {display: false,},
    plugins: {datalabels: {color: 'white',formatter: (value, context) =>
      [context.dataset.label, value].join(' ')
    }}
  }
}"/>
</p>

<br>

# Mods Loading Time
<p align="center">
<img src="https://quickchart.io/chart?w=400&h=300&c={
  type: 'outlabeledPie',
  options: {
    cutoutPercentage: 25,
    plugins: {
      legend: !1,
      outlabels: {
        stretch: 5,
        padding: 1,
        text: (v,i)=>[
          v.labels[v.dataIndex],' ',
          (v.percent*1000|0)/10,
          String.fromCharCode(37)].join('')
      }
    }
  },
  data: {...
`
3e76ba  18.31s Just Enough Items;
386AA7  30.10s Just Enough Items (Plugins);
386AA7  33.65s Just Enough Items (Ingredient Filter);
8c2ccd  18.02s Immersive Engineering;
214d9e  17.36s Minecraft Forge;
5161a8   4.93s CraftTweaker2;
495797   7.62s CraftTweaker2 (Script Loading);
516fa8  11.98s Ender IO;
a651a8  11.76s IndustrialCraft 2;
8f3087  10.98s Forge Mod Loader;
813e81   8.51s OpenComputers;
538f30   7.59s Animania;
8f304e   7.46s Astral Sorcery;
8f6c30   5.10s Dynamic Surroundings;
6e175e   4.54s Recurrent Complex;
9e2174   4.49s Tinkers' Construct;
213664   4.44s Forestry;
436e17   4.09s Integrated Dynamics;
a86e51   4.03s Extra Utilities 2;
308f53   3.71s Village Names;
216364   3.24s Thermal Expansion;
6e3a17   3.21s Quark;
ba3eb8   3.15s Cyclic;
444444  76.26s 43 Other mods;
333333  52.45s 154 'Fast' mods (load 1.0s - 0.1s);
222222   6.83s 224 'Instant' mods (load %3C 0.1s)
`
    .split(';').reduce((a, l) => {
      l.match(/(\w{6}) *(\d*\.\d*)s (.*)/)
      .slice(1).map((a, i) => [[String.fromCharCode(35),a].join(''), parseFloat(a), a][i])
      .forEach((s, i) => 
        [a.datasets[0].backgroundColor, a.datasets[0].data, a.labels][i].push(s)
      );
      return a
    }, {
      labels: [],
      datasets: [{
        backgroundColor: [],
        data: [],
        borderColor: 'rgba(22,22,22,0.3)',
        borderWidth: 1
      }]
    })
  }
}"/>
</p>

<br>

# Top Mods Details (except JEI, FML and Forge)
<p align="center">
<img src="https://quickchart.io/chart?w=400&h=450&c={
  options: {
    scales: {
      xAxes: [{stacked: true}],
      yAxes: [{stacked: true}],
    },
    plugins: {
      datalabels: {
        anchor: 'end',
        align: 'top',
        color: 'white',
        backgroundColor: 'rgba(46, 140, 171, 0.6)',
        borderColor: 'rgba(41, 168, 194, 1.0)',
        borderWidth: 0.5,
        borderRadius: 3,
        padding: 0,
        font: {size:10},
        formatter: (v,ctx) => 
          ctx.datasetIndex!=ctx.chart.data.datasets.length-1 ? null
            : [((ctx.chart.data.datasets.reduce((a,b)=>a- -b.data[ctx.dataIndex],0)*10)|0)/10,'s'].join('')
      },
      colorschemes: {
        scheme: 'office.Damask6'
      }
    }
  },
  type: 'bar',
  data: {...(() => {
    let a = { labels: [], datasets: [] };
`
1: Construction;
2: Loading Resources;
3: PreInitialization;
4: Initialization;
5: InterModComms$IMC;
6: PostInitialization;
7: LoadComplete;
8: ModIdMapping
`
    .split(';')
      .map(l => l.match(/\d: (.*)/).slice(1))
      .forEach(([name]) => a.datasets.push({ label: name, data: [] }));
`
                          1      2      3      4      5      6      7      8  ;
Immersive Engineering |  0.84|  0.01|  1.13|  0.86|  0.00| 15.18|  0.00|  0.00;
CraftTweaker2         |  0.57|  0.00|  3.62|  0.01|  0.00|  8.35|  0.01|  0.00;
Ender IO              |  1.64|  0.01|  4.33|  0.55|  4.07|  0.16|  0.00|  1.22;
IndustrialCraft 2     |  0.81|  0.01|  8.76|  0.93|  0.00|  1.26|  0.00|  0.00;
OpenComputers         |  0.16|  0.01|  5.15|  3.01|  0.18|  0.00|  0.00|  0.00;
Animania              |  0.31|  0.00|  3.28|  0.23|  0.00|  3.76|  0.00|  0.00;
Astral Sorcery        |  0.24|  0.00|  4.80|  1.38|  0.00|  1.04|  0.00|  0.00;
Dynamic Surroundings  |  0.15|  0.00|  0.19|  0.11|  0.00|  0.06|  4.59|  0.00;
Recurrent Complex     |  0.27|  0.00|  0.62|  1.04|  0.00|  2.60|  0.00|  0.00;
Tinkers' Construct    |  1.00|  0.01|  0.15|  0.05|  0.01|  3.27|  0.00|  0.00;
Forestry              |  0.40|  0.01|  2.76|  0.94|  0.00|  0.33|  0.00|  0.00;
Integrated Dynamics   |  0.21|  0.01|  3.83|  0.05|  0.00|  0.00|  0.00|  0.00
`
    .split(';').slice(1)
      .map(l => l.split('|').map(s => s.trim()))
      .forEach(([name, ...arr], i) => {
        a.labels.push(name);
        arr.forEach((v, j) => a.datasets[j].data[i] = v)
      }); return a
  })()}
}"/>
</p>

<br>

# TOP JEI Registered Plugis
<p align="center">
<img src="https://quickchart.io/chart?w=700&c={
  options: {
    elements: { rectangle: { borderWidth: 1 } },
    legend: false
  },
  type: 'horizontalBar',
    data: {...(() => {
      let a = {
        labels: [], datasets: [{
          backgroundColor: 'rgba(0, 99, 132, 0.5)',
          borderColor: 'rgb(0, 99, 132)',
          data: []
        }]
      };
`
  4.69: crazypants.enderio.machines.integration.jei.MachinesPlugin;
  3.73: com.rwtema.extrautils2.crafting.jei.XUJEIPlugin;
  2.94: li.cil.oc.integration.jei.ModPluginOpenComputers;
  2.74: cofh.thermalexpansion.plugins.jei.JEIPluginTE;
  2.11: mezz.jei.plugins.vanilla.VanillaPlugin;
  1.43: jeresources.jei.JEIConfig;
  1.36: com.github.sokyranthedragon.mia.integrations.jer.JeiJerIntegration$1;
  1.22: forestry.factory.recipes.jei.FactoryJeiPlugin;
  1.08: ic2.jeiIntegration.SubModule;
  1.02: com.buuz135.thaumicjei.ThaumcraftJEIPlugin;
  0.93: com.buuz135.industrial.jei.JEICustomPlugin;
  0.68: nc.integration.jei.NCJEI;
  0.65: mctmods.smelteryio.library.util.jei.JEI;
  0.59: knightminer.tcomplement.plugin.jei.JEIPlugin;
  0.51: crazypants.enderio.base.integration.jei.JeiPlugin;
  4.42: Other 118 Plugins
`
        .split(';')
        .map(l => l.split(':'))
        .forEach(([time, name]) => {
          a.labels.push(name);
          a.datasets[0].data.push(time)
        })
        ; return a
    })()
  }
}"/>
</p>

<br>

# FML Stuff
<p align="center">
<img src="https://quickchart.io/chart?w=500&h=400&c={
  options: {
    rotation: Math.PI,
    cutoutPercentage: 55,
    plugins: {
      legend: !1,
      outlabels: {
        stretch: 5,
        padding: 1,
        text: (v)=>v.labels
      },
      doughnutlabel: {
        labels: [
          {
            text: 'FML stuff:',
            color: 'rgba(128, 128, 128, 0.5)',
            font: {size: 18}
          },
          {
            text: [233.07,'s'].join(''),
            color: 'rgba(128, 128, 128, 1)',
            font: {size: 22}
          }
        ]
      },
    }
  },
  type: 'outlabeledPie',
  data: {...(() => {
    let a = {
      labels: [],
      datasets: [{
        backgroundColor: [],
        data: [],
        borderColor: 'rgba(22,22,22,0.3)',
        borderWidth: 2
      }]
    };
`
993A00   2.10s Loading sounds;
994400   2.16s Loading Resource - SoundHandler;
994F00  51.31s ModelLoader: blocks;
995900  10.84s ModelLoader: items;
996300   9.19s ModelLoader: baking;
996D00   6.27s Applying remove recipe actions;
997700   0.51s Applying remove furnace recipe actions;
998200  33.57s Indexing ingredients;
444444 117.13s Other
`
    .split(';')
      .map(l => l.match(/(\w{6}) *(\d*\.\d*)s (.*)/))
      .forEach(([, col, time, name]) => {
        a.labels.push([name, ' ', time, 's'].join(''));
        a.datasets[0].data.push(parseFloat(time));
        a.datasets[0].backgroundColor.push([String.fromCharCode(35), col].join(''))
      })
      ; return a
  })()}
}"/>
</p>

<br>

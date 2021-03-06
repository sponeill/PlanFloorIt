﻿<build-menu>
    <div class="menuContainer">

        <div id="menuTabsContainer">
            <div class="glass tab">
                <div class="menuTab activeMenuTab" id="materialTab" onclick="{switchMaterialType}">Flooring</div>
            </div>
            <div class="glass tab">
                <div class="menuTab" id="otherTab" onclick="{switchMaterialType}"><i class="fa fa-couch-l"></i>Other<i class="fa fa-couch-l"></i></div>
            </div>
        </div>


        <div class="materialsContainer" id="otherSection" if={!isFloors}>

            <div class="materials" id="objectMaterials">

                <div class="material" each="{object, index in objects}" id="object-{index}">
                    <div class="material-container" ondblclick="{ addObject }">
                        <img src="/Content/{object.ImageSource}" class="matImg" style="border-style:none; box-shadow: none" />
                        <p>{object.Name}</p>
                    </div>
                </div>
            </div>
        </div>


        <div class="materialsContainer" id="materialSection" if={isFloors}>


            <div class="materials" id="floorMaterials">

                <div class="material" each="{floor, index in floors}" id="floor-{index}">
                    <div onclick="{ setMaterial }" class="material-container" style="background-image: url('/Content/{floor.ImageSource}')">
                        <p>{floor.Name}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style type="text/css">
        .menuContainer {
            transition-duration: 0.4s;
            margin: auto;
            background-color: #d7bbd9;
            background-repeat: repeat;
            width: 100%;
            display: inline-block;
            border: 10px solid black;
            box-shadow: inset 0 0 10px #000;
        }

        div.glass.tiles {
            background-color: rgba(255, 255, 255, 0.30);
            height: 100px;
            border-radius: 5px;
            margin: 5px;
            padding: 10px;
            box-shadow: 0 0 10px #000;
        }

            div.glass.tiles::before {
                -webkit-filter: blur(30px);
                filter: blur(30px);
                content: '';
                z-index: -1;
            }

        .materialsContainer {
            width: 100%;
            height: 200px;
        }

        .materials {
            height: 100%;
            -webkit-flex-wrap: wrap;
            flex-wrap: wrap;
            -webkit-flex-direction: row;
            flex-direction: row;
            display: flex;
            margin-top: 15px;
        }

            .materials p {
                display: block;
                position: absolute;
                top: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 90%;
                text-align: center;
                color: black;
                margin: 30px 0;
                padding: 5px;
                font-size: 1.5rem;
                font-weight: 600;
                border-radius: 5px;
            }


        .material-container {
            display: inline-block;
            height: 100px;
            width: 150px;
            border-radius: 5px;
            margin: auto;
            position: relative;
        }

        #materialSection {
            width: 100%;
        }

        .matImg {
            display: block;
            max-width: 150px;
            max-height: 100px;
            width: auto;
            height: auto;
            transition-duration: 0.4s;
            margin: 0 20%;
            cursor: pointer;
        }



        div.slick-track {
            width: 100%;
        }

        #menuTabsContainer {
            color: black;
            display: flex;
            font-size: 2rem;
            font-family: sans-serif;
            font-weight: 600;
            width: 100%;
            margin-top: 0.5em;
        }

        .menuTab {
            display: inline-block;
            margin: auto;
            transition-duration: 0.4s;
            color: black;
            padding: 10px;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
        }

        .meunTab:hover {
            color: white;
        }

        .activeMenuTab {
            border-radius: 5px;
            background-color: black;
            color: white;
        }

        .glass.tab {
            justify-content: space-around;
            text-align: center;
            width: 50%;
        }

        .material {
            display: flex;
            flex-direction: column;
        }
    </style>

    <script type="text/javascript">
        this.floors = [];
        this.objects = [];
        this.isFloors = true;
        this.currentMenuType = "material";
        this.inputGrade = document.getElementsByName("grade");

        this.on("mount", function () {
            console.log("loaded");
            this.getMaterials();
        });

        this.getMaterials = function () {

            const url = '/api/materials';

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    this.objects = data.filter(o => o.IsMaterial === false);
                    this.floors = data.filter(o => o.IsMaterial === true);
                    this.opts.bus.trigger("getFloorCosts", this.floors);
                    console.log(this.objects);
                    console.log(this.floors);
                    this.update();

                });
        }

        this.setMaterial = function () {
            console.log("Set Material " + this.floor.ImageSource);

            this.opts.bus.trigger("setMaterial", this.floor.ImageSource);
        }

        this.addObject = function () {
            console.log("Object: " + this.object.ImageSource);
            this.opts.bus.trigger("addObject", this.object.ImageSource);

        }

        this.switchMaterialType = function () {
            this.isFloors = !this.isFloors;
            this.materialTab = document.getElementById('materialTab');
            this.otherTab = document.getElementById('otherTab');
            if (this.isFloors) {
                this.materialTab.classList.add('activeMenuTab');
                this.otherTab.classList.remove('activeMenuTab');
                this.update();

            }
            else {
                this.otherTab.classList.add('activeMenuTab');
                this.materialTab.classList.remove('activeMenuTab');
                this.update();

            }
        }
    </script>
</build-menu>
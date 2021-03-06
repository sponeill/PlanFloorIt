﻿<room-menu>
    <div class="roomContainer">
        <!--<img src="/Content/padlock-key.svg" onclick="{ switchLock }" class="lock">-->
        <!--<i onclick="{ switchZoom }" class="fa fa-search-plus {activated: isZoom}"></i>-->
            <button class="roomBtn newRoom accountformbtn" onclick="{newRoom}">New room</button>
        <img src="/Content/garbage.svg" onclick="{ deleteRoom }" class="trash">
		

        <input if="{!showName}" id="roomNameTextBox" type="hidden" placeholder="New room">
        <span style="visibility:hidden" id="roomName">{activeRoom.name}</span>

        <button type="button" id="door" onclick="{ addDoor }">Door</button>
        <button type="button" id="stairs" onclick="{ addStairs }">Stairs</button>
        <button type="button" id="window" onclick="{ addWindow }">Window</button>
        <input type="hidden" class="saveRoom" onclick="{ addRoom }" value="Save">

    </div>

    <style>


        .roomContainer {
            height: 100%;
            display: grid;
            padding: 10px;
            grid-gap: 5px;
            grid-template-areas: 'trash new new new new ...' '... name name name name ...' 'rotate name name name name ...' '... details details details details ...' 'door ... window window ... stairs';
            background-image: url("/Content/PLYWOOD.jpg");
            box-shadow: inset 0 0 10px #000;
            box-sizing: border-box;
            z-index: 0;
        }

            .roomContainer button {
                background-color: black;
                color: white;
                transition-duration: 0.4s;
                border-radius: 5px;
                font-size: 1.0rem;
                font-weight: 600;
                border-style: none;
                cursor: pointer;
            }

                .roomContainer button:hover {
                    cursor: pointer;
                    box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);
                }


        .roomBtn.newRoom {
            display: inline-block;
            grid-area: new;
            font-size: 1.5rem;
            font-weight: 600;
            padding: 1px;
        }

        #door {
            grid-area: door;
        }

        #stairs {
            grid-area: stairs;
        }

        #window {
            grid-area: window;
        }

        .saveRoom {
            grid-area: details;
            transition-duration: 0.4s;
            display: inline-block;
            margin: auto;
            background-color: white;
            font-weight: 600;
            font-size: 2rem;
            border-radius: 5px;
            border-style: none;
        }

        #roomName {
            background-color: white;
            display: inline-block;
            font-size: 3rem;
            font-weight: 600;
            margin: auto;
            text-align: center;
            border-radius: 5px;
            padding: 10px;
            box-shadow: inset 0 0 10px #000;
            grid-area: name;
        }

        #roomNameTextBox {
            text-align: center;
            font-size: 3rem;
            grid-area: name;
            border-radius: 5px;
            border-style: none;
            margin: auto;
        }

        .fa {
            height: 25px;
            vertical-align: top;
            font-size: 1rem;
        }


        img.trash {
            margin: auto;
            grid-area: trash;
            width: 2.0rem;
            cursor: pointer;
        }

		img.rotate {
			margin: auto;
			grid-area: rotate;
			width: 2.0rem;
			cursor: pointer;
		}

        img.lock {
            margin: auto;
            grid-area: lock;
            width: 2.0rem;
            cursor: pointer;
        }

        .createdRoom {
            border: 1px solid black;
        }

        .roomImgContainer {
            display: inline-block;
            margin: 0 auto;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            width: 25%;
            top: 5%;
        }

        .roomImg {
            width: 100%;
        }

        .addPaintAndLights {
            position: absolute;
            bottom: 0;
            width: 100%;
            display: flex;
            text-align: center;
        }

        .paintLightButton {
            width: 50%;
        }

        .sideRoomPanel {
            position: absolute;
            right: 10%;
        }

        i {
            font-size: 2.5rem !important;
            margin: .5em 0;
            display: block !important;
        }

        .activated {
            background-color: black;
            color: white;
        }

        .switchButtons {
            width: 100%;
        }

        .room-name {
            
        }
    </style>

    <script>

		var showName;
		
        this.opts.bus.on("setMaterial", data => {
            this.setMaterial(data);

            console.log("Material: " + data);
            this.update();
        });

        this.opts.bus.on("changeRoom", data => {
            this.activeRoom = data;
            this.setBackgroundStyle(data.flooring);
			console.log("****");
			showName = true;
			this.save.setAttribute("type", "hidden");
			this.element.setAttribute("type", "hidden");
			this.span.style.visibility = "visible";
            this.update();
            
        });

		this.opts.bus.on("updateCurrentRoom", data => {
			showName = true;
			this.save.setAttribute("type", "hidden");
			this.element.setAttribute("type", "hidden");
			this.span.style.visibility = "visible";
            this.updateCurrentRoom(data);
            console.log("12312312321");
        });

        this.opts.bus.on("updateRoomCost", data => {
            console.log("Room Cost: " + data);
            this.activeRoom.cost = data;
            console.log(this.activeRoom);
            console.log(this.rooms);
        });

        function Room(name) {
            this.name = name;
            this.flooring;
            this.hasPaint = false;
            this.hasLights = false;
            this.area;
            this.cost = 0;
        }

        this.switchPaint = function () {
            this.currentRoom.hasPaint = !this.currentRoom.hasPaint;
        }
        this.switchLights = function () {
            this.currentRoom.hasLights = !this.currentRoom.hasLights;
        }

        this.switchZoom = function () {
            this.isZoom = !this.isZoom;
        }

        this.switchLock = function () {
            this.isLocked = !this.isLocked;
        }

        //const living = new Room("Living");
        //const family = new Room("Family");
        //const rooms = [living, family];

        this.activeRoom = null;
        this.totalRoomCost;
        this.roomIndex = -1;
        this.rooms = [];
        this.currentRoom = null;
        this.createdRooms = [];
        this.createdRooms = document.querySelectorAll('.createdRoom');
        this.isZoom = false;
        this.isLocked = false;
        let curAngle;

        this.currentMaterial = "/Content/plywood.jpg";

        this.on("mount", function () {

            this.span = document.querySelector("#roomName");
            this.element = document.querySelector('#roomNameTextBox');
            this.save = document.querySelector(".saveRoom");
            this.mainDiv = document.querySelector(".roomContainer");
		});

		this.rotateObject = function () {

			let object = this.getActive();
			curAngle = object.angle;
			let newAngle = curAngle + 90;

            console.log("Rooootate");

			this.opts.bus.trigger("rotateObject", newAngle);
		}

        this.deleteRoom = function () {

            this.element = document.querySelector('#roomNameTextBox');

            this.opts.bus.trigger("deleteRoom", this.currentRoom);

            this.rooms.splice(this.roomIndex, 1);

            if (this.rooms.length > 0) {
                this.currentRoom = this.rooms[0];
                this.roomIndex = 0;
                element.value = this.currentRoom.name;
            }
            else {
                this.currentRoom = null;
                this.roomIndex = -1;
                element.value = "";
            }

            this.update();
        }

        this.addDoor = function () {
            this.opts.bus.trigger("addDoor");
        }

        this.addStairs = function () {
            this.opts.bus.trigger("addStairs");
        }

        this.addWindow = function () {
            this.opts.bus.trigger("addWindow");
        }

		this.newRoom = function () {
			showName = false;
			this.activeRoom = null;
            this.element.value = '';
			this.save.setAttribute("type", "button");
			this.element.setAttribute("type", "text");
			this.span.style.visibility = "hidden";
            this.update();
        }

		this.addRoom = function () {

            var room = new Room(this.element.value);
            this.rooms.push(room);
            console.log(this.rooms);
            this.roomIndex++;
			this.activeRoom = this.rooms[this.roomIndex];
			this.element.setAttribute("type", "hidden");
			this.span.style.visibility = "visible";
            this.activeRoom.flooring = "/Content/plywood.jpg";
            this.setBackgroundStyle(this.activeRoom.flooring);
            this.opts.bus.trigger("newRoom", this.activeRoom);

            
			this.save.setAttribute("type", "hidden");
			this.element.setAttribute("type", "hidden");
			showName = true;
            this.update();
        }

        this.setMaterial = function (material) {
            this.currentMaterial = `/Content/${material}`;
            this.activeRoom.flooring = this.currentMaterial;
            this.setBackgroundStyle(this.currentMaterial);
            this.update();
        }

        this.updateCurrentRoom = function (index) {
			console.log("indndnndnndnd " + index);
			showName = true;
			this.save.setAttribute("type", "hidden");
			this.element.setAttribute("type", "hidden");
			this.span.style.visibility = "visible";

            this.currentRoom = this.rooms[this.roomIndex];

            let element = document.querySelector('#roomNameTextBox');
            element.value = this.currentRoom.name;

            this.update();
        }

        this.setBackgroundStyle = function (material) {

            if (material === null) {
                material = "/Content/plywood.jpg";
            }

            this.mainDiv.style.backgroundImage =  `url('${material}')`;
            console.log("main div --- " + this.mainDiv);
            this.update();
        }

        this.getActive = function () {

            this.opts.bus.trigger("getActive");

            this.opts.bus.on("sendActive", data => {
                this.activeRoom = data;
            });
			showName = true;
			this.save.setAttribute("type", "hidden");
			this.element.setAttribute("type", "hidden");
			this.span.style.visibility = "visible";
            return this.activeRoom;
        }

    </script>
</room-menu>
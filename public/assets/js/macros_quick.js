

window.onload =   function(){

    const rectangulos = document.querySelectorAll('.rectangulo');

    for(let i=0;i<rectangulos.length;i++){

        rectangulos[i].addEventListener("click",function(event){

            const name = this.querySelector("span[data-name]").textContent

            //window.location.href=  "http://"+window.location.host+"/macros/runQuick/"+name;

            const cancelText=document.getElementById('msg_cancel').value
            const confirmText=document.getElementById('msg_ok').value
            var placeHolder=document.getElementById('msg_placeHolder').value
            const error=document.getElementById('msg_error').value

            const jsonDevices=JSON.parse(this.querySelector('#devices').textContent)


            let devices=[]

            for(let j=0;j<jsonDevices.length;j++){

                devices.push(jsonDevices[j].id+"-"+jsonDevices[j].nombre+"-"+jsonDevices[j].ip)

            }

            devicesModal(name,devices,cancelText,confirmText,placeHolder,error);


        })

    };



}


function lessQuickFunctions(){

    const isDisabled= document.querySelector("#moveBack").classList.contains("aIsDisabled");

    if(!isDisabled) {
        const all = document.querySelectorAll(".rectangulo");
        var one = null;

        for(var i=0;i<all.length;i++){
            if(!all[i].classList.contains("rectDisabled")){
                one = all[i];
                break;
            }


        }
        const val = ((one.id).match(/\d/i))[0];

        const now = parseInt(val);

        const next = parseInt(now)-4;

        for(var i = now;i<(now+4);i++){
            if( document.querySelector("#rect"+i.toString())) {

                document.querySelector("#rect" + i.toString()).classList.add("rectDisabled");

            }
        }


        for(var i = next;i<(next+4);i++){

            if( document.querySelector("#rect"+i.toString())){
                document.querySelector("#rect"+i.toString()).classList.remove("rectDisabled");

            }

        }

        if(document.querySelector("#moveNext").classList.contains("aIsDisabled")){
            document.querySelector("#moveNext").classList.remove("aIsDisabled");
        }

        if(1>= (next)){
            document.querySelector("#moveBack").classList.add("aIsDisabled");
        }


    }

};

function moreQuickFunctions(){


    const isDisabled= document.querySelector("#moveNext").classList.contains("aIsDisabled");
    if(!isDisabled) {
        const all = document.querySelectorAll(".rectangulo");
        var one = null;

        for(var i=0;i<all.length;i++){
            if(!all[i].classList.contains("rectDisabled")){
                one = all[i];
                break;
            }


        }

        const val = ((one.id).match(/\d/i))[0];

        const now = parseInt(val);

        const next = parseInt(now)+4;

        for(var i = now;i<(now+4);i++){


            document.querySelector("#rect"+i.toString()).classList.add("rectDisabled");

        }


        for(var i = next;i<(next+4);i++){

            if( document.querySelector("#rect"+i.toString())){
                document.querySelector("#rect"+i.toString()).classList.remove("rectDisabled");

            }

        }

        if(document.querySelector("#moveBack").classList.contains("aIsDisabled")){
            document.querySelector("#moveBack").classList.remove("aIsDisabled");
        }

        if(all.length<= (next+4)){
            document.querySelector("#moveNext").classList.add("aIsDisabled");
        }


    }

};

async function devicesModal(name, devices, cancelText,confirmText,placeHolder,error){

    Swal.fire({
        titleText: name,
        input: 'select',
        inputOptions: devices,
        inputPlaceholder: placeHolder,
        showCancelButton: true,
        confirmButtonText: confirmText,
        cancelButtonText: cancelText,
        showLoaderOnConfirm:true,

        inputValidator: (value) => {

            return new Promise((resolve) => {

                if (value === "") {
                    resolve(error)
                } else {
                    resolve()
                }
            })
        },
        preConfirm: (devicePos) => {

            const expDev=((devices[devicePos]).split("-"))
            const idDev=expDev[0]
            const nameDev=expDev[1]

            return fetch(`/macros/runQuick/${idDev}/${nameDev}/${name}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(response.statusText)
                    }
                    return response.json()
                })
                .catch(error => {
                    Swal.showValidationMessage(
                        `Request failed: ${error}`
                    )
                })
        },
        allowOutsideClick: () => !Swal.isLoading()
        })
        .then((result) => {

            const json=result.value
            if (json.status) {
                Swal.fire({
                    icon: json.status,
                    title: json.sub,
                    text: json.msg,
                    footer: json.footer

                })
            }else if (json.value) {
                Swal.fire({
                    title: `${value.login}'s avatar`,
                    imageUrl: value.avatar_url
                })
            }
        })



}

var icons = [];
icons["glass"]="\uf000";
icons["music"]="\uf001";
icons["search"]="\uf002";
icons["envelope-o"]="\uf003";
icons["heart"]="\uf004";
icons["star"]="\uf005";
icons["user"]="\uf007";
icons["film"]="\uf008";
icons["times"]="\uf00d";
icons["power-off"]="\uf011";
icons["signal"]="\uf012";
icons["cog"]="\uf013";
icons["home"]="\uf015";
icons["file-o"]="\uf016";
icons["clock-o"]="\uf017";
icons["road"]="\uf018";
icons["download"]="\uf019";
icons["inbox"]="\uf01c";
icons["refresh"]="\uf021";
icons["flag"]="\uf024";

function downloadByRepo(hrefLink){

    fetch(hrefLink)
        .then(function(response) {
            return response.json();
        })
        .then(function(res) {

            const macro = res.data
            const myName = macro.user+'/'+macro.name;
            const withoutSpaces= myName.replace( /\s/g, '');
            const possibleName= withoutSpaces.replace( /\//g, '_');

            Swal.fire({
                title: write_macro_new,
                input: 'text',
                inputValue: possibleName,
                inputValidator: (value) => {

                    let found = false
                    const notAllowed=['<','>',':','"','|','?','*','/','.','\\']

                    length = notAllowed.length;
                    while(length--) {
                        if (value.indexOf(notAllowed[length])!=-1) {
                            found=true
                        }
                    }

                    if (!value) {
                        return can_not_empty
                    }else if(found){
                        return bad_characters

                    }
                },
                inputAttributes: {
                    autocapitalize: 'off'
                },
                showCancelButton: true,
                cancelButtonText: cancel_text,
                confirmButtonText: download_text,
                showLoaderOnConfirm: true,
                preConfirm: (input) => {
                    return fetch(window.location.origin+'/macros/checkMacroName/'+btoa(input.trim())+'/'+btoa(JSON.stringify(macro)))
                        .then(response => {
                            if (!response.ok) {
                                throw new Error(response.json())
                            }
                            return response.json()
                        })
                        .catch(error => {
                            Swal.showValidationMessage(
                                name_not_free
                            )
                        })
                },
                allowOutsideClick: () => !Swal.isLoading()
            }).then((result) => {
                if (result)
                    result=result.value
                if (result.status=='success') {
                    Swal.fire({
                        icon: 'success',
                        title: result.msg,
                    })
                }else{
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: result.msg,
                    })
                }
            })
        })
        .catch(function(error) {

            Swal.fire({
                icon: 'error',
                title: 'Oops...',
                text: error.message,
            })

        });

}


$(document).ready(function () {

    var ntotali = 0;
    var ntotalc = 0;
    var creaOActualiza= document.getElementById("_macros_crear_num_inputs")?'crear':'actualizar';

    $("#inputs_list").on("click", ".remove_field", function () {
        var n = document.getElementById("_macros_"+creaOActualiza+"_num_inputs").value;
        var n = parseInt(n) - 1;
        document.getElementById("_macros_"+creaOActualiza+"_num_inputs").value = n;
        //console.log("total inputs->"+n)
        $(this).parent('div').remove();

    });

    $("#commands_list").on("click", ".remove_field", function () {
        var n = document.getElementById("_macros_"+creaOActualiza+"_num_commands").value;
        var n = parseInt(n) - 1;
        document.getElementById("_macros_"+creaOActualiza+"_num_commands").value = n;
        //console.log("total commands->"+n)

        $(this).parent('div').remove()
    });


    $("#moreInputs").click(function () {
        var n = document.getElementById("_macros_"+creaOActualiza+"_num_inputs").value;
        var n = parseInt(n) + 1
        ntotali = parseInt(ntotali) + 1
        document.getElementById("_macros_"+creaOActualiza+"_num_inputs").value = n;
        //console.log("total inputs->"+n)

        var ident = "input".concat(ntotali);
        var label = "Input".concat(ntotali);
        $("#inputs_list").append("<div  class=\"form-group\"><label for='_macros_"+creaOActualiza+"_"+label+"'>" + label + "</label></br>" +
            "<input class='col-xs-10' type='text' id='_macros_"+creaOActualiza+"_" + ident + "' name=/macros/"+creaOActualiza+"[" + ident + "]>" +
            "<button type='button' class='remove_field' ><i class='fa fa-minus-circle' aria-hidden='true'></i> " +
            "</button><button  type='button' id=i_move_up"+n+" class='i_move_up' > <i class='fa fa-arrow-circle-up' aria-hidden='true'></i></button>" +
            "<button type='button' id=i_move_down"+n+" class='i_move_down' > <i class='fa fa-arrow-circle-down' aria-hidden='true'></i></button></div>");

    });



    $("#moreCommands").click(function () {
        var n = document.getElementById("_macros_"+creaOActualiza+"_num_commands").value;
        var n = parseInt(n) + 1;
        ntotalc = parseInt(ntotalc) + 1;
        document.getElementById("_macros_"+creaOActualiza+"_num_commands").value = n;
        //console.log("total commands->"+n)

        var ident = "command".concat(ntotalc)
        var label = "Command".concat(ntotalc)
        $("#commands_list").append("<div class=\"form-group\"><label for='_macros_"+creaOActualiza+"_"+label+"'l>" + label + "</label></br>" +
            "<input class='col-xs-10' type='text' id='_macros_"+creaOActualiza+"_" + ident + "' name=/macros/"+creaOActualiza+"[" + ident + "]>" +
            "<button type='button' class='remove_field' ><i class='fa fa-minus-circle' aria-hidden='true'></i> </button>" +
            "<button type='button' id=c_move_up"+n+" class='c_move_up' > <i class='fa fa-arrow-circle-up' aria-hidden='true'></i></button>" +
            "<button type='button' id=c_move_down"+n+" class='c_move_down' > <i class='fa fa-arrow-circle-down' aria-hidden='true'></i></button></br></div>");


    });
    $("#inputs_list").on("click", ".i_move_up", function () {
        // console.log("MOVE UP")

        var id = $(this).attr('id');
        var reg= (/(\d+$)/).exec(id)[0];
        var regs=reg-1;
        try{
            var yo=document.getElementById('_macros_'+creaOActualiza+'_input'+reg).value;

            var antes=document.getElementById('_macros_'+creaOActualiza+'_input'+regs).value;
        }catch(err){
            // console.log(err)
        }


        var i=0;
        var encontrado=false;

        while ((yo!=null || antes!=null) && i<10 && !encontrado) {
            //console.log(reg)

            if (yo != null && antes != null) {
                document.getElementById('_macros_'+creaOActualiza+'_input' + reg).value = antes;

                document.getElementById('_macros_'+creaOActualiza+'_input' + regs).value = yo;
                encontrado = true;
            } else {

                i++;
                regs=parseInt(reg)-parseInt(i);
                try{
                    antes=document.getElementById('_macros_'+creaOActualiza+'_input'+regs).value;
                }catch(err){
                }
                //console.log(i);

            }
        }
    });

    $("#inputs_list").on("click", ".i_move_down", function () {
        // console.log("MOVE DOWN")
        var id = $(this).attr('id');
        var reg= (/(\d+$)/).exec(id)[0];
        var regs=parseInt(reg)+1;
        try{
            var yo=document.getElementById('_macros_'+creaOActualiza+'_input'+reg).value;
            var $despues=document.getElementById('_macros_'+creaOActualiza+'_input'+regs).value;
        }catch(err){
            // console.log(err)
        }

        var i=0;
        var encontrado=false;

        while ((yo!=null || $despues!=null) && i<10 && !encontrado){

            if(yo!=null && $despues!=null){
                document.getElementById('_macros_'+creaOActualiza+'_input'+reg).value=$despues;
                document.getElementById('_macros_'+creaOActualiza+'_input' + regs).value = yo;

                encontrado=true;
            }else{
                i++;
                regs=parseInt(reg)+parseInt(i);
                try{
                    $despues=document.getElementById('_macros_'+creaOActualiza+'_input'+regs).value;
                }catch(err){
                }


            }

            //console.log(i);

        }

    });

    $("#commands_list").on("click", ".c_move_up", function () {
        //console.log("MOVE UP")

        var id = $(this).attr('id');
        var reg= (/(\d+$)/).exec(id)[0];
        var regs=reg-1;
        try{
            var yo=document.getElementById('_macros_'+creaOActualiza+'_command'+reg).value;

            var antes=document.getElementById('_macros_'+creaOActualiza+'_command'+regs).value;
        }catch(err){
            //console.log(err)
        }


        var i=0;
        var encontrado=false;

        while ((yo!=null || antes!=null) && i<10 && !encontrado) {
            //console.log(reg)

            if (yo != null && antes != null) {
                document.getElementById('_macros_'+creaOActualiza+'_command' + reg).value = antes;

                document.getElementById('_macros_'+creaOActualiza+'_command' + regs).value = yo;
                encontrado = true;
            } else {

                i++;
                regs=parseInt(reg)-parseInt(i);
                try{
                    antes=document.getElementById('_macros_'+creaOActualiza+'_command'+regs).value;
                }catch(err){
                }
                //console.log(i);

            }
        }
    });

    $("#commands_list").on("click", ".c_move_down", function () {
        //console.log("MOVE DOWN")
        var id = $(this).attr('id');
        var reg= (/(\d+$)/).exec(id)[0];
        var regs=parseInt(reg)+1;
        try{
            var yo=document.getElementById('_macros_'+creaOActualiza+'_command'+reg).value;
            var $despues=document.getElementById('_macros_'+creaOActualiza+'_command'+regs).value;
        }catch(err){
            //console.log(err)
        }

        var i=0;
        var encontrado=false;

        while ((yo!=null || $despues!=null) && i<10 && !encontrado){

            if(yo!=null && $despues!=null){
                document.getElementById('_macros_'+creaOActualiza+'_command'+reg).value=$despues;
                document.getElementById('_macros_'+creaOActualiza+'_command' + regs).value = yo;

                encontrado=true;
            }else{
                i++;
                regs=parseInt(reg)+parseInt(i);
                try{
                    $despues=document.getElementById('_macros_'+creaOActualiza+'_command'+regs).value;
                }catch(err){
                }


            }


        }

    });

    showIcons();

    const address= $("#repo_address").val();

    $('#repo').DataTable( {
        "ajax": address+'/api/macros',
        "order": [[ 6, "desc" ]],
        "columns": [
            { "data": "name" },
            { "data": "user" },
            { "data": "manufacturer" },
            { "data": "os_version" },
            { "data": "rating" },
            { "data": "downloads" },
            { "data": "updated_at" },
            { "data": undefined },
        ],
        "columnDefs": [
            {

                "render": function ( data, type, row ) {

                    return ' <button class="btn btn-danger dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">\n' +
                         actions_text +
                        '                                <span class="caret"></span>\n' +
                        '                              </button>\n' +
                        '                              <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">\n' +
                        '                                <li><a target="_blank" href='+row.href.link.replace('api/','')+'>'+details_text+'</a></li>\n' +
                        '                                <li><a onclick="downloadByRepo(\''+row.href.link+'\')">'+download_text+'</a></li>\n' +
                        '\n' +
                        '                              </ul>';
                },
                className: 'dropdown' ,
                "targets": 7
            },
        ],
    } );

});

function showIcons(){


    const creaOActualiza= document.getElementById("_macros_crear_num_inputs")?'crear':'actualizar';
    const select=document.getElementById("_macros_"+creaOActualiza+"_icon");
    const val=(select)?select.getAttribute("value"):undefined;


    if(select){

        let flag=false;
        let pos =0;
        let i=0;
        let indices = Object.getOwnPropertyNames(icons);
        delete indices[0]
        for (var index in indices){
            const value=indices[index]
            const option = document.createElement("option");
            option.setAttribute("value","fa-"+value);
            option.textContent=icons[value];


            if((val!="") && (val=="fa-"+value) && (creaOActualiza==="actualizar")){
                pos=i;
                option.setAttribute("selected","selected")

            }
            if(!flag && creaOActualiza==="crear"){
                flag=true;
                console.log(i)

                option.setAttribute("selected","selected")
            }

            select.appendChild(option)

            i++;

        };

    }



}


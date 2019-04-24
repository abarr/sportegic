let Role = {

    setup_role_form(){
       let all_checkboxes = document.querySelectorAll("input[type=checkbox]");
       [].forEach.call(all_checkboxes, function (el) {
            el.addEventListener("click", event => {
                if(el.hasAttribute("data-all")){
                    let parent = document.getElementById("row_" + el.id)
                    let cb_children = parent.querySelectorAll("input[type=checkbox]");
                    if(!el.checked){
                        [].forEach.call(cb_children, function(cb){
                            cb.checked = false;
                        });    
                    } else{
                        [].forEach.call(cb_children, function(cb){
                            cb.checked = true;
                        }); 
                    }
                }else{
                    if(!el.checked){
                        let parent = el.closest('.col').parentElement
                        let all = parent.querySelectorAll('input[data-all]')
                        el.checked = false;
                        all[0].checked = false;
                        
                    } else{
                        if(el.nextSibling.innerHTML != "View"){
                            let parent = el.closest('.col').parentElement
                            let cbs = parent.querySelectorAll("input[type=checkbox]");
                            
                            [].forEach.call(cbs, function(cb){
                                console.log(cb)
                                let s = cb.nextSibling("span")
                                if(s[0].innerHTML == "View"){
                                    cb.checked = true;
                                }
                            })
                            
                        }
                        el.checked = true;
                    }
                }
            });
        });
    }

}

export default Role
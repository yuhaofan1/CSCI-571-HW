/*clear button js functions*/
var keyword;
var distance;
var category;
var loc_global;
var search_endpoint_ipinfo = "https://uschw-364223.uw.r.appspot.com/search";
var detail_endpoint = "https://uschw-364223.uw.r.appspot.com/detail_search/";
var search_endpoint_location_input = "https://uschw-364223.uw.r.appspot.com/search_loc";

var noresults;
var google_locations;
var geo_latitude;
var geo_longitude;
// var search_endpoint_location_input = "http://127.0.0.1:8080/search_loc";
// var search_endpoint_ipinfo = "http://127.0.0.1:8080/search";
// var detail_endpoint = "http://127.0.0.1:8080/detail_search/";
var bus_asc=false;
var rating_asc = false;
var distance_asc = false;


function ClearFields() {
    keyword = "";
    distance ="";
    category = "Default";
    loc = "";
    document.getElementById("keyword_box").value=keyword;
    document.getElementById("location_box").value=loc;
    document.getElementById("distance_box").value=distance;
    document.getElementById("Category_box").value=category;
    document.getElementById("autodetect").checked = false;
    document.getElementById("location_box").disabled=false;
    document.getElementById("summary_title").innerHTML="";
    document.getElementById("summary_body").innerHTML="";
    document.getElementById("details_text").innerHTML="";
    document.getElementById("details_img").innerHTML="";
    document.getElementById("details_text").style.border = '0px';

}    




function ipinfo(){
    let request = new XMLHttpRequest();
    request.open("GET","https://ipinfo.io/json?token=d26467ba90b0fe",true);
    request.send();
    request.onload= () => {
        if(request.status==200 && request.readyState==4){
            // console.log(JSON.parse(request.response));
            myObj = JSON.parse(request.response);
            // console.log(myObj.loc)
            myArray = myObj.loc.split(",");
            
            latitude = myArray[0];
            console.log("latitude is: " + latitude);            
            longitude = myArray[1];
            console.log("longitude is: " + longitude);
            loc_global = myObj['city'];
            // document.getElementById('location_box').value=myObj['city'];
        }else{
            console.log(request.status);
        }
    } 
    
}
function check_box(){
    if(document.getElementById("autodetect").checked){
        document.getElementById('location_box').value="";
        document.getElementById('location_box').disabled=true;
        ipinfo();
        // console.log(loc_global + "in check box");
    }else{
        document.getElementById('location_box').value="";
        document.getElementById('location_box').disabled=false;
    }
}


async function google_geo_location(){
    var parseaddress = document.getElementById("location_box").value;
    var replaced = parseaddress.replace(' ', '+');
    var geo_request = "https://maps.googleapis.com/maps/api/geocode/json?address="+replaced+'&key=AIzaSyDGpDXOqfc4VGUo9ZAleZvjIJNLpQxLsx4';

    try{
        return fetch(
            geo_request
            ).then(response => {
                return response.json(); //.json() return a native javascript object
            }).then(data => {
                console.log(data);
                if(data.results.length>0){
                    geo_latitude = data.results[0].geometry.location.lat;
                    geo_longitude = data.results[0].geometry.location.lng;
                    console.log(geo_latitude);
                    console.log(geo_longitude);
                }else{
                    noresults=true;
                }
            })
    }catch(e) {
        console.log(e);
    }
    

}

async function Submit(){

    document.getElementById("details_text").style.border = '0px';

    var keyword = document.getElementById('keyword_box');

    // if(keyword.value==""){
    //     alert('No valid customer added.');
    //     document.getElementById('keyword_box').focus();    
    // }else{
        document.getElementById("summary_title").innerHTML="";
        document.getElementById("summary_body").innerHTML="";
        document.getElementById("details_text").innerHTML="";
        keyword = document.getElementById("keyword_box").value;
        distance_double = document.getElementById("distance_box").value * 1600;
        distance = parseInt(distance_double);
        console.log("distance is: " + distance)

        var e = document.getElementById("Category_box");
        var text = e.options[e.selectedIndex].text;
        if(!document.getElementById("autodetect").checked){
            loc_global = document.getElementById("location_box").value;
        }
        // console.log("selected keyword_box:" + keyword);
        // console.log("selected distance_box:" + distance);
        // console.log("selected category:" + text);
        // console.log("selected loc_global:" + loc_global);

        
        if(keyword!="" && loc_global!="" && distance>0 && document.getElementById("location_box").value!=""){
            API_KEY = 'o6ULqSmNfzy_kkBnDBVulE1MhcXYx3VinJGYtIhrxq4z-7rhcy-7x9fBw_cL8Zw9V4XM8pPLuFv3-xvrNlskeXQYBo1FxbmrYM-LXfSGOXGiFXYDzjF-sneBWBwhY3Yx'
            HEADERS = {'Authorization': 'bearer %s' % API_KEY}

                console.log("google_locations is: " + geo_latitude);                
                // console.log("google_locations is: " + geo_longitude);
                // // console.log("long google is: " + long_google);
                // console.log( search_endpoint_ipinfo +'&' + latitude +'&'+ long +'&' + distance +'&' + keyword +'&' + text              );
                // https://api.yelp.com/v3/businesses/search?term=coffee&radius=232&location=Los Angeles
            
                const json = await this.google_geo_location();  // command waits until completion

                console.log("google_locations is after await: " + json);                
               
                console.log(search_endpoint_ipinfo +'&' +"latitude="+geo_latitude +'&'+ "longitude="+geo_longitude +'&' + "radius="+distance +'&' + "term="+keyword +'&' + "categories="+text  
                )
                if(!noresults){
                    fetch( 
                        search_endpoint_ipinfo +'&' +"latitude="+geo_latitude +'&'+ "longitude="+geo_longitude +'&' + "radius="+distance +'&' + "term="+keyword +'&' + "categories="+text  
                        )
                    .then(response => { // response object
                        return response.json(); //.json() return a native javascript object
                    })
                    .then( data => { // array
                        length = data.total; // total number of results
                        if(length>0){
                            var data_out = data.businesses;
                            var number = 0;
                            image = data.businesses[number].image_url; // image
                            business_name = data.businesses[number].name; //business Name
                            rating = data.businesses[number].rating; //business rating
                            // const dis = data.business[number].distance; // distance
                            document.querySelector('#summary_body').
                            insertAdjacentHTML('afterbegin', "<h1></h1>")
                            build_table(data_out);
                            rebuild_summary_body(data_out)
                        }else{
        
                            console.log("No data found")
                            tbl= document.createElement('table');
                            tbl.style.textAlign='center';
                            tbl.style.width  = '900px';
                            var tr = tbl.insertRow();
                            var td = tr.insertCell();
                            td.innerHTML = "No record has been found";
                            document.getElementById("summary_title").appendChild(tbl);
                            document.getElementById("summary_title").style.textAlign = "center";
                            document.getElementById("location_box").disabled = false;
                        
                        }
                    })
                    .catch(error => {
                        console.log(error);
                    }) 
                }else{
                    console.log("Address is wrong")
                    var address_error = document.createTextNode("Address is wrong")
                    noresults = false;
                    document.getElementById("summary_title").style.textAlign = "center";

                    document.getElementById("summary_title").appendChild(address_error);
                }

                
            

            // console.log("google_locations is: " + google_locations);
        }


        //use ipinfo
        if(keyword!="" && loc_global!="" && distance>0 && document.getElementById("autodetect").checked){
        
            ipinfo();
            console.log("ipinfo is called: ")
            API_KEY = 'o6ULqSmNfzy_kkBnDBVulE1MhcXYx3VinJGYtIhrxq4z-7rhcy-7x9fBw_cL8Zw9V4XM8pPLuFv3-xvrNlskeXQYBo1FxbmrYM-LXfSGOXGiFXYDzjF-sneBWBwhY3Yx'
            HEADERS = {'Authorization': 'bearer %s' % API_KEY}
            console.log(                search_endpoint_ipinfo +'&' +"latitude="+latitude +'&'+ "longitude="+longitude +'&' + "radius="+distance +'&' + "term="+keyword +'&' + "categories="+text              );

            // https://api.yelp.com/v3/businesses/search?term=coffee&radius=232&location=Los Angeles
            fetch( 
                
                
                search_endpoint_ipinfo +'&' +"latitude="+latitude +'&'+ "longitude="+longitude +'&' + "radius="+distance +'&' + "term="+keyword +'&' + "categories="+text  

                // search_endpoint + "term="+keyword +'&' + "radius="+distance +'&' + "location="+loc_global +"&" +"categories="+text+"?"
            )
            .then(response => { // response object
                return response.json(); //.json() return a native javascript object
            })
            .then( data => { // array 

                length = data.total; // total number of results

                if(length>0){
                    var data_out = data.businesses;
                    var number = 0;
                    image = data.businesses[number].image_url; // image
                    business_name = data.businesses[number].name; //business Name
                    rating = data.businesses[number].rating; //business rating
                    // const dis = data.business[number].distance; // distance
                    document.querySelector('#summary_body').
                    insertAdjacentHTML('afterbegin', "<h1></h1>")
                    build_table(data_out);
                    rebuild_summary_body(data_out)
                }else{

                    console.log("No data found")
                    tbl= document.createElement('table');
                    tbl.style.textAlign='center';
                    tbl.style.width  = '900px';
                    var tr = tbl.insertRow();
                    var td = tr.insertCell();
                    td.innerHTML = "No record has been found";
                    document.getElementById("summary_title").appendChild(tbl);
                    document.getElementById("summary_title").style.textAlign = "center";
                    document.getElementById("location_box").disabled = false;
                
                }


            })
            .catch(error => {
                console.log(error);
            })

        }
    }

function build_table(data){
    tableCreate(data);
    document.getElementById("details_text").innerHTML="";
    document.getElementById("details_img").innerHTML="";
}

function tableCreate(data){

    console.log(data);
    
    
    tbl  = document.createElement('table');
    tbl.setAttribute("id","scroll_summary")

    tbl.style.textAlign='center';
    tbl.style.width  = '900px';
    

    // tbl.style.border = '.5px solid black';
    var tr = tbl.insertRow();
    var td = tr.insertCell();
    td.style.width = '160px';
    td.style.height = '30px';
    td.style.background = 'royalblue';

    let btn = document.createElement("button");
    btn.innerHTML = 'No.';
    btn.setAttribute("class", "table_button"); 
    td.appendChild(btn);


    var td = tr.insertCell();
    td.style.width = '310px';
    td.style.height = '30px';

    td.style.background = 'royalblue';
    let btn1 = document.createElement("button");
    btn1.innerHTML = 'Image';
    btn1.setAttribute("class", "table_button"); 
    td.appendChild(btn1);


    // resort data by business name when clicked this button.
    var td = tr.insertCell();
    td.style.width = '560px';
    td.style.height = '30px';
    td.style.background = 'royalblue';
    let btn2 = document.createElement("button");
    btn2.innerHTML = 'Business Name';
    btn2.setAttribute("class", "table_button"); 
    td.appendChild(btn2);
    btn2.addEventListener("click", ()=>{
        document.getElementById("summary_body").innerHTML="";
        if(get_bus_asc()==true){
            console.log("True get_bus")
            sortResults(data,'name', true);
        }else{
            console.log("false get_bus")
            sortResults(data,'name', false);
        }
    });


    var td = tr.insertCell();
    td.style.width = '150px';
    td.style.height = '30px';

    td.style.background = 'royalblue';

    let btn3= document.createElement("button");
    btn3.innerHTML = 'Rating';
    btn3.setAttribute("class", "table_button"); 
    td.appendChild(btn3);
    btn3.addEventListener("click", ()=>{
        document.getElementById("summary_body").innerHTML="";
        if(get_rating_asc()==true){
            sortResults(data,'rating', true);
        }else{
            sortResults(data,'rating', false);
        }
    });

    var td = tr.insertCell();
    td.style.width = '133px';
    td.style.height = '30px';

    td.style.background = 'royalblue';
    let btn4 = document.createElement("button");
    btn4.innerHTML = 'Distance(miles)';
    btn4.setAttribute("class", "table_button"); 
    td.appendChild(btn4);
    btn4.addEventListener("click", ()=>{
        document.getElementById("summary_body").innerHTML="";
        if(get_distance_asc()==true){
            sortResults(data,'distance', true);
        }else{
            sortResults(data,'distance', false);
        }
    });

    document.getElementById("summary_title").appendChild(tbl);
    document.getElementById("summary_title").style.textAlign = "center";

    document.getElementById("autodetect").checked = false;
    document.getElementById("location_box").disabled=false;

};


function get_bus_asc(){
    
    console.log(bus_asc + "before change");
    if(bus_asc==true){
        bus_asc = false;
    }else{
        bus_asc = true;
    }
    console.log(bus_asc + "after change");

    return bus_asc;
}

function get_rating_asc(){
    
    console.log(rating_asc + "before change");
    if(rating_asc==true){
        rating_asc = false;
    }else{
        rating_asc = true;
    }
    console.log(rating_asc + "after change");

    return rating_asc;
}

function get_distance_asc(){
    
    console.log(rating_asc + "before change");
    if(distance_asc==true){
        distance_asc = false;
    }else{
        distance_asc = true;
    }
    console.log(distance_asc + "after change");

    return distance_asc;
}

function sortResults(data, prop, asc){
    console.log("rebuild_summary called");

        data.sort(function(a, b) {
            if (asc) {
                return (a[prop] > b[prop]) ? 1 : ((a[prop] < b[prop]) ? -1 : 0);
            } else {
                return (b[prop] > a[prop]) ? 1 : ((b[prop] < a[prop]) ? -1 : 0);
            }
        });
        console.log("sort result exe")
        console.log("ASC is: " + asc)
        console.log(data);
        rebuild_summary_body(data);   
}
//building summary table body
function rebuild_summary_body(data){
    tbl  = document.createElement('table');
    tbl.style.textAlign='center';
    tbl.style.width  = '900px';
    tbl.style.height  = '200px';

    for(var i = 0; i < data.length; i++){
        //Create the row of the table
        var tr = tbl.insertRow();

        //create the first cell number No.
        var td = tr.insertCell();
        td.style.width = '150px';
        td.appendChild(document.createTextNode(i+1));
        td.style.border = '1px solid black';

        //create the second cell image
        var td = tr.insertCell();
        var img = new Image();
        img.src = data[i].image_url;
        img.alt = "no image found";
        img.style.width = '70%';
        img.style.height = "150px";
        td.appendChild(img);
        td.style.border = '1px solid black';
        td.style.width = '300px';
        td.style.height = '150px';

        //create the third cell business name
        var td = tr.insertCell();
        td.style.width = '500px';
        const button = document.createElement('b_name_button');
        button.innerHTML = data[i].name;
        button.setAttribute("business_id", data[i].id);
        td.appendChild(button);
        td.style.border = '1px solid black';
        // Attach the "click" event to your button
        button.addEventListener("click", function() {
            get_detail(button.getAttribute('business_id'));
        });

        //create the fourth cell rating
        var td = tr.insertCell();
        td.style.width = '150px';
        td.style.textAlign="center";
        td.appendChild(document.createTextNode(data[i].rating));
        td.style.border = '1px solid black';

        //create the fifth cell distance
        var td = tr.insertCell();
        td.style.width = '150px';
        td.style.textAlign = "center"
        // td.appendChild(document.createTextNode(data[i].distance.toFixed(2)));
        var dis = data[i].distance/1609;
        td.appendChild(document.createTextNode(dis.toFixed(2)));

        td.style.border = '1px solid black';   
        
    }
    document.getElementById('summary_body').innerHTML='';
    document.getElementById('summary_body').appendChild(tbl);
    document.getElementById("summary_body").style.textAlign = "center";
}



function reply_click(id){
    console.log(id);
}

function get_detail(business_id){

    // console.log(detail_endpoint + business_id);
    fetch(detail_endpoint + business_id)
    .then((response) => response.json())
    .then((data) => create_detail_table(data));

}


function create_detail_table(data){

    console.log("passed in data is: " + data);
    document.getElementById("details_text").innerHTML="";

    const paragraph = document.createElement("h3");
    //extract the name of business
    const b_name = document.createTextNode(data.name);
    paragraph.appendChild(b_name);

    var divider = document.createElement("hr");
    paragraph.appendChild(divider);

    paragraph.style.textAlign='center';
    paragraph.style.width  = '900px';

    
    //create a table for business detail
    tbl  = document.createElement("table");
    tbl.style.textAlign='left';
    tbl.style.width  = '900px';

    var tr_one = tbl.insertRow();
    var td_left = tr_one.insertCell();
    td_left.style.width = '450px';
    var td_right = tr_one.insertCell();
    td_right.style.width = '450px';


    //hours status section
    if(data.hours!=null){
        var p_left = document.createElement("h3");
        p_left.appendChild(document.createTextNode("Status"));
        var p_left_down = document.createElement("p");
        
        if(data.hours[0].is_open_now){
            p_left_down.setAttribute('id', 'open_color');
            // document.getElementById("open_color").style.backgroundColor = "green";
            var store_status = document.createTextNode("Open Now")
            p_left_down.appendChild(store_status);
            p_left_down.style.backgroundColor = 'LightGreen'
            p_left_down.style.width = '100px'
            p_left_down.style.height = '35px'
            p_left_down.style.textAlign = 'center'
            p_left_down.style.borderRadius = "15px"
        }else{
            p_left_down.appendChild(document.createTextNode("Closed Now"));
            p_left_down.style.backgroundColor = 'salmon'
            p_left_down.style.width = '120px'
            p_left_down.style.height = '35px'
            p_left_down.style.textAlign = 'center'
            p_left_down.style.borderRadius = "15px"

        }   
    }
    //categories section

    try{
        if(data.categories.length>0){
            td_left.appendChild(p_left);
            td_left.appendChild(p_left_down);
            var p_right = document.createElement("h3");
            p_right.appendChild(document.createTextNode("Category"));
            var p_left_down = document.createElement("p");
            
            var cat = "";
            for(var i=0;i< data.categories.length-1;i++){
                cat = cat + data.categories[i].title + ' | ';
            }
        
            cat = cat + data.categories[data.categories.length-1].title;
            p_left_down.appendChild(document.createTextNode(cat));
            td_right.appendChild(p_right);
            td_right.appendChild(p_left_down); 
        }
    }catch(e){

    }



    //Address section

    var tr_two = tbl.insertRow();
    var td_left = tr_two.insertCell();
    var td_right = tr_two.insertCell(); 

    var address = "";
    if(data.location.display_address.length>0){
        var p_left = document.createElement("h3");
        p_left.appendChild(document.createTextNode("Address"));
        var p_left_down = document.createElement("p");
        for(var i=0;i< data.location.display_address.length;i++){
            address = address + data.location.display_address[i] + ' ';
        }
    
        p_left_down.appendChild(document.createTextNode(address));
        td_left.appendChild(p_left);
        td_left.appendChild(p_left_down);
    }


    
    //phone number section
    if(data.display_phone==""){
    }else{
        var p_right = document.createElement("h3");
        p_right.appendChild(document.createTextNode("Phone Number"));
        td_right.appendChild(p_right);
        console.log(data.display_phone)
        var p_right_down = document.createElement("p");
        p_right_down.appendChild(document.createTextNode(data.display_phone));
        td_right.appendChild(p_right);
        td_right.appendChild(p_right_down);
    }
    var tr_two = tbl.insertRow();
    var td_left = tr_two.insertCell();
    var td_right = tr_two.insertCell(); 


    //transaction section
    if(data.transactions.length!=0){
    var p_left = document.createElement("p");
    var p_left = document.createElement("h3");
    p_left.appendChild(document.createTextNode("Transactions Supported"));
    var p_left_bottom = document.createElement("p");
    var trans = "";
    for(var i=0;i< data.transactions.length-1;i++){
        trans = trans + data.transactions[i] + ' | ';
    }
    trans = trans + data.transactions[data.transactions.length-1];
    p_left_bottom.appendChild(document.createTextNode(trans));

    td_left.appendChild(p_left);
    td_left.appendChild(p_left_bottom);
    }


    //price section

    if(data.hasOwnProperty('price')){
    var p_right = document.createElement("h3");
    p_right.appendChild(document.createTextNode("Price"));
    var p_right_bottom = document.createElement("p");
    p_right_bottom.appendChild(document.createTextNode(data.price));
    td_right.appendChild(p_right);
    td_right.appendChild(p_right_bottom);
    }
    

    var tr_two = tbl.insertRow();
    var td_left = tr_two.insertCell();
    var td_right = tr_two.insertCell(); 

    //yelp link section

    if(data.url!=null){
        var p_left = document.createElement("h3");
        p_left.appendChild(document.createTextNode("More information"));

        var p_left_bottom = document.createElement('a'); 
        
        p_left_bottom.target = "_blank";
                    
        // Create the text node for anchor element.
        var link = document.createTextNode("Yelp");
        
        // Append the text node to anchor element.
        p_left_bottom.appendChild(link); 
        
        // Set the title.
        p_left_bottom.title = "Yelp"; 
        
        // Set the href property.
        p_left_bottom.href = data.url; 
        
        // Append the anchor element to the body.
        p_left.appendChild(document.body.appendChild(p_left_bottom)); 

        td_left.appendChild(p_left);
        td_left.appendChild(p_left_bottom);
    }

    document.getElementById("details_text").appendChild(paragraph);
    document.getElementById("details_text").appendChild(tbl);

    create_img(data);

    document.getElementById("details_text").style.border =  "thick solid #808080";
    document.getElementById("details_text").style.padding = "25px";
    document.getElementById("details_text").style.marginTop = "25px";


}

function create_img(data){


        document.getElementById("details_img").innerHTML="";  
        //create a table for 
        tbl  = document.createElement("table");

        var num_pictures = data.photos.length;
    
        tbl.style.textAlign='left';
        tbl.style.marginTop = '20px';
        tbl.style.width  = '870px';
        var tr_img = tbl.insertRow();
        var img_one = tr_img.insertCell();
        var img_num = tbl.insertRow();
        var img_txt = img_num.insertCell();
        var two_txt = img_num.insertCell();
        var three_txt = img_num.insertCell();
       


        if(num_pictures>=1){
            img_one.style.width = '290px';
            img_one.style.height = '400px';
            img_one.style.borderWidth = "2px";
            img_one.style.borderColor = "#000";
            img_one.style.borderStyle = "solid";
            var first_img = document.createElement("img");

            first_img.style.width = '290px';
            first_img.setAttribute('src', data.photos[0]);
            img_one.appendChild(document.body.appendChild(first_img));
            // var text_one = document.createTextNode("img 1")
            // img_txt.style.textAlign = "center";
            // img_txt.appendChild(document.body.appendChild(text_one))

        
            img_txt.style.borderWidth = "2px";
            img_txt.style.borderColor = "#000";
            img_txt.style.borderStyle = "solid"; 
            img_txt.style.textAlign = "center"; 
            img_txt.appendChild(document.createTextNode("Photo 1"))

        
        img_one.style.textAlign = "center";
        if(num_pictures > 1){
            var img_two = tr_img.insertCell();
            img_two.style.width = '290px';
            img_two.style.height = '400px';
            img_two.style.borderWidth = "2px";
            img_two.style.borderColor = "#000";
            img_two.style.borderStyle = "solid";
            var second_img = document.createElement("img");
            second_img.style.width = '290px';
            second_img.setAttribute('src', data.photos[1]);
            img_two.appendChild(document.body.appendChild(second_img));
            two_txt.style.borderWidth = "2px";
            two_txt.style.borderColor = "#000";
            two_txt.style.borderStyle = "solid";
            two_txt.style.textAlign = "center"; 
            two_txt.appendChild(document.createTextNode("Photo 2"))

        
        }
        if(num_pictures > 2){
            var img_three = tr_img.insertCell();

            var three_img = document.createElement("img");
            img_three.style.width = '290px';
            img_three.style.height = '400px';

            img_three.style.borderWidth = "2px";
            img_three.style.borderColor = "#000";
            img_three.style.borderStyle = "solid";
            three_img.style.width = "290px";

            three_img.setAttribute('src', data.photos[2]);
            img_three.appendChild(document.body.appendChild(three_img));
            // img_three.appendChild(document.body.appendChild(document.createTextNode("img 3")))
            // img_three.style.textAlign = "center";

            three_txt.style.borderWidth = "2px";
            three_txt.style.borderColor = "#000";
            three_txt.style.borderStyle = "solid";
            three_txt.style.textAlign = "center"; 
            three_txt.appendChild(document.createTextNode("Photo 3"))

        }

        document.getElementById("details_text").appendChild(tbl);
    }else{
        document.getElementById("details_text").appendChild(document.createTextNode("No image found!"));

    }

}

function yelp_clicked(yelp_url){
    console.log("YELP CLICKED");
    window.open(URL,yelp_url);

}

function api(){

    // let url = 'http://127.0.0.1:8080/search';
    let url = 'https://uschw-364223.uw.r.appspot.com/search';
    fetch(url,{mode: 'no-cors'}) //{mode: 'no-cors'}
    .then(data => console.log(data))
}

async function call_api(){
    const result = await api();

    console.log("call_api finished");
    console.log(result.json());
}


 

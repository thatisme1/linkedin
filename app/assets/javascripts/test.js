
  function check_form_input()
  {
      var a = document.getElementById("user_fname");
      var d = document.getElementById("user_email");
      var b = document.getElementById("user_lname");
      var c = document.getElementById("user_password");
      var ans=true;
      if(a.value=="")
        {document.getElementById("firstname_error").style.display="block";ans=false}
      else document.getElementById("firstname_error").style.display="";

       if(b.value=="")
        {document.getElementById("lastname_error").style.display="block";ans=false;}
      else document.getElementById("lastname_error").style.display="";


      if(c.value==""){
        document.getElementById("nopassword").style.display="block";
        document.getElementById("wrongpassword").style.display="";ans=false;}
      else if(c.value.length<6){
        document.getElementById("wrongpassword").style.display="block";
        document.getElementById("nopassword").style.display="";
        ans = false;
      }
      else {
        document.getElementById("wrongpassword").style.display="";
        document.getElementById("nopassword").style.display="";
      }

      if(d.value==""){
        document.getElementById("noemail").style.display="block";ans=false;
        document.getElementById("wrongemail").style.display="";}
      else if(d.value.length<3){
        document.getElementById("wrongemail").style.display="block";ans=false;
        document.getElementById("noemail").style.display="";
      }
      else {
        document.getElementById("wrongemail").style.display="";
        document.getElementById("noemail").style.display="";
      }

      if(!ans)
        document.getElementById("global-error").style.display="block";
      else document.getElementById("global-error").style.display="";
      return ans;

  }



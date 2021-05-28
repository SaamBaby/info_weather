class WeatherIcon{


 String getIcon(int iconCode, String iconString){
   String tempString;
    if(iconString.contains('d'))
    {
      if(iconCode>=200&&iconCode<300){
        tempString='assets/weather/001lighticons-26.svg';

      }  else if(iconCode>=300&&iconCode<400)
      {
        tempString='assets/weather/001lighticons-18.svg';
      }
      else if(iconCode>=500&&iconCode<600)
      {
        tempString='assets/weather/001lighticons-20.svg';
      }else if(iconCode>=600&&iconCode<700)
      {
        tempString='assets/weather/001lighticons-23.svg';
      }else if(iconCode>=700&&iconCode<800)
      {
        tempString='assets/weather/001lighticons-05.svg';
      }else if(iconCode>=800&&iconCode<820)
      {
        tempString='assets/weather/001lighticons-08.svg';
      }
      else if(iconCode==800){
        tempString='assets/weather/001lighticons-02.svg';
      }
      // for night
     } else if(iconString.contains('n')){
      if(iconCode<=200&&iconCode<300){
        tempString='assets/weather/001lighticons-26.svg';

      }  else if(iconCode<=300&&iconCode<400)
      {
        tempString='assets/weather/001lighticons-18.svg';
      }
      else if(iconCode<=500&&iconCode<600)
      {
        tempString='assets/weather/001lighticons-20.svg';
      }else if(iconCode<=600&&iconCode<700)
      {
        tempString='assets/weather/001lighticons-23.svg';
      }else if(iconCode<=700&&iconCode<800)
      {
        tempString='assets/weather/001lighticons-05.svg';
      }else if(iconCode<=800&&iconCode<820)
      {
        tempString='assets/weather/001lighticons-08.svg';
      }
      else if(iconCode==800){
        tempString='assets/weather/001lighticons-02.svg';
      }
    }
      return tempString;
  }

}
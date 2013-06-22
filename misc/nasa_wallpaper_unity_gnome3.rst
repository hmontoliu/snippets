Change unity/gnome wallpaper using NASA daily images
===================================================================

Simple code to change background in unity or gnome-shell using as source the NASA's `image of the day`__

.. __: http://www.nasa.gov/multimedia/imagegallery/iotd.html

::

    ~$ BG=~/bg.jpg; wget -qO - http://www.nasa.gov/rss/lg_image_of_the_day.rss  |\
       grep -Po '(?<=url=")http.[^ ]*jpg' |\ 
       wget -i - -qO $BG; gsettings set org.gnome.desktop.background picture-uri file://$BG

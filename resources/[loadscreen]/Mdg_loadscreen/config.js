CONFIG = {
    feathercore: {
        active: false
    },
    image: {
        active: false, // If you want an image background make this flag true (but make sure youtube/video is false)
        source: "url('nui://Mdg_loadscreen/ui/assets/background.png')",
        backgroundcolor: "#4d4d4d",
        random: {
            active: false, //If set to true, a random image from Sources will be chosed on player connection. Warning: The image.source will be ignored if set to true.
            sources: [
                "url('nui://Mdg_loadscreen/ui/assets/background.png')",
                "url('nui://Mdg_loadscreen/ui/assets/images/background1.jpg')",
                "url('nui://Mdg_loadscreen/ui/assets/images/background2.jpg')",
                "url('nui://Mdg_loadscreen/ui/assets/images/background3.jpeg')"
            ],
            rotate: {
                active: false, // If true, the loadscreen will rotate between images every x seconds
                sequenced: false,  // Images show in order, if false, random image will be chosen each time.
                time: 5, // Roate image every x seconds
            }
        },
    },
    video: {
        active: true, //If you want a local video make this flag true (but make sure image/youtube is false)
        source: "nui://Mdg_loadscreen/ui/assets/video.mp4",
        looped: true, // If the video is not looped then the loadscreen will "close" when the video ends. otherwise it will loop until the loading is actually done.
        mute: false,
        volume: 0.5, //between 0-1
    },
    youtube: {
        active: false, //If you want a youtube video make this flag true (but make sure image/video is false)
        source: "",
        looped: false, // If the video is not looped then the loadscreen will "close" when the video ends. otherwise it will loop until the loading is actually done.
        mute: false,
        volume: 50 // 0 - 100
    },
    googledrive: {
        active: false, //If you want a youtube video make this flag true (but make sure image/video is false)
        source: "<YOUR VIDEO ID>", //ID of your google drive video. 1: Make the video shared with anyone with the link, then copy the link Example: https://drive.google.com/file/d/<YOUR VIDEO ID>/view
        looped: false, // If the video is not looped then the loadscreen will "close" when the video ends. otherwise it will loop until the loading is actually done.
        mute: false,
        volume: 0.5, //between 0-1
    },
    audio: {
        active: false,
        source: 'nui://Mdg_loadscreen/ui/assets/music.mp3',
        volume: 0.5, //between 0-1
    },
    loadtime: {
        skip: false, //Skip will only occur after the main game has loaded (this cannot be skipped)
        lang: "Press Space to Skip Load Screen"
    },
    timeelapsed: true,
    loading: {
        active: true, //Do you want the loading icon to show
        icon: "fadedots", // Options: https://github.com/BryceCanyonCounty/bcc-loadscreen/wiki/Loading-Spinner-Options
        color: "#942626"
    }
}
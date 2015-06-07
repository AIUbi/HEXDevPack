# HEXDevPack
Pack of advanced functions for Expression2 / Пак продвинутых функций для Е2

* Hello, if you're reading this there are 2 options, you're looking for new features to e2 or you're tired of e2p which is not updated and do not work well .
I want you to enjoy this offer packs, it is only beginning to develop, but will soon have all necessary functions at its best.
If you catch a bad realzatsyu or you want participate in this project, create a pool-request or offer anything you'd like to see in future versions .
All this is done on a voluntary basis , and if there is a desire to join the project.

* Здравствуй, если ты это читаешь есть 2 варианта, ты в поисках новых функций дл е2 или ты устал от е2p который не обновляется и вообще плохо работает.
Я хочу тебе предложить пользоваться этим паком, он еще только начала развиваться, но в скоре будет иметь все необходимые функции в лучшем виде.
Если ты заметишь плохую реалзацю или ты захочешь поучавствовать в этом проекте, создай pool-request или предложи что-бы ты хотел увидеть в будущих версиях.
Все это делается на добровольной основе, и если будет желание, присоединяйся к проекту.

* Installation

1. Download the ZIP archive.
2. Unpack in addons.
3. Enjoy.

* Установка

1. Скачай Зип архив.
2. Распакуй в аддоны.
3. Вперед и с песней.

# Sound core

| Function name      | Args type | Return type | Cost | Args names                          | Description                                                                                |
|--------------------|:---------:|:-----------:|:----:|-------------------------------------|--------------------------------------------------------------------------------------------|
| soundLoadURL       |    n,s    |     void    |  10  | Index, URL                          | Create new sound with URL and parent to E2                                                 |
| soundLoadURL       |  n,s,n,n  |     void    |  10  | Index, URL, Volume, Noplay?         | Create new sound with URL, Volume and Play or not and parent to E2                         |
| soundLoadURL       | n,s,v,n,n |     void    |  10  | Index, URL, Vector, Volume, Noplay? | Create new sound with URL and parent to E2, Vector position, Volume and with Noplay 0 or 1 |
| soundPauseURL      |     n     |     void    |  10  | Index                               | Pause channel if is exists and owner as client                                             |
| soundPlayURL       |     n     |     void    |  10  | Index                               | Unpause\Play channel if is exists and owner as client                                      |
| soundStopURL       |     n     |     void    |  10  | Index                               | Stop and remove channel if is exitst on client                                             |
| soundVolumeURL     |    n,n    |     void    |  10  | Index, Volume                       | Set the volume for station                                                                 |
| soundPositionURL   |    n,v    |     void    |  10  | Index, Vector                       | Set the station position if is no have parent entity                                       |
| soundStopAll       |    void   |     void    |  50  | void                                | Stop all sounds on client                                                                  |
| soundSetFFT        |    n,n    |     void    |  10  | Index, Enabled (0 or 1)             | Enable\Disable FFT on channel.                                                             |
| soundSetFFTAttribs |    n,n    |     void    |  10  | Index, Enabled (0 or 1)             | Enable\Disable FFT Attributes (Name, Time, Length, Bitrate) on channel.                    |
| soundSetFFTBitrate |    n,n    |     void    |  10  | Index, Enabled 1, 2, 3, 4, 5        | Set the bitrate for channel 1 = 128 2 = 256 3 = 512 4 = 1024 5 = 2048                      |
| soundGetFFT        |     n     |      a      |  10  | Index                               | Return the FFT array (spectrum of sound)                                                   |
| soundGetName       |     n     |      n      |  10  | Index                               | Return name or URL link from channel                                                       |
| soundGetTime       |     n     |      n      |  10  | Index                               | Return current play time                                                                   |
| soundGetLength     |     n     |      n      |  10  | Index                               |                                                                                            |
| soundParentTo      |    n,e    |     void    |  10  | Index, Entity                       | Parent channel to entity                                                                   |
| soundGetAttribs    |     n     |      a      |  30  | Index, Array                        | Return array of attribs (Name, Time, Length, Bitrate)                                      |
|                    |           |             |      |                                     |                                                                                            |
![SoundCore Circular visualizator0](http://puu.sh/ifUBw/498b7afeb1.jpg)
![SoundCore Circular visualizator1](http://puu.sh/ifUVW/aa219f6d03.jpg)

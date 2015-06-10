# HEXDevPack
Pack of advanced functions for Expression2 / Пак продвинутых функций для Е2

* Hello, if you're reading this there are 2 options, you're looking for new features to e2 or you're tired of e2p which is not updated and do not work well .
I want you to enjoy this offer packs, it is only beginning to develop, but will soon have all necessary functions at its best.
If you catch a bad realzatsyu or you want participate in this project, create a Pool request or offer anything you'd like to see in future versions .
All this is done on a voluntary basis , and if there is a desire to join the project.

* Здравствуй, если ты это читаешь есть 2 варианта, ты в поисках новых функций дл е2 или ты устал от е2p который не обновляется и вообще плохо работает.
Я хочу тебе предложить пользоваться этим паком, он еще только начала развиваться, но в скоре будет иметь все необходимые функции в лучшем виде.
Если ты заметишь плохую реалзацю или ты захочешь поучавствовать в этом проекте, создай Pool request или предложи что-бы ты хотел увидеть в будущих версиях.
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

It supports asynchronous and multi-threading work. If I use some of the same channels E2 I can get access to the same channel through one or another E2 . But I can not get access to foreign channels. If E2 update the information will continue to go , do not forget to use , ``` if (last ()) {soundStopURL ( 1 ) } . ```
Поддерживает асинхронную и многпоточную обработку, если я буду использовать несколько Е2 с одним и тем же аудиоканалом я смогу получить доступ к каналу и принять из него частотный спектр или произвести другие манипуляции. но я не смогу получиь доступ к каналам у которых я не являюсь владельцем. Если Е2 обновится то канал сохранится и будет так передавать информацию как будто ее не было. Не забывайте использовать вот это ``` if (last ()) {soundStopURL ( 1 ) } . ```

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

```
@name example_fft
@persist [E]:entity I End
if(first())
{
    runOnTick(1)
    runOnLast(1)
    E = entity()
    
    soundSetFFT(1,1)
    soundSetFFTAttribs(1,1)
    soundSetFFTBitrate(1,2)
    soundParentTo(1,E)
    
    soundLoadURL(1,"https://LINK_TO_YOUR_FILE.mp3",E:pos(),1,0)
}
if(!End && holoCanCreate())
{ 
    I++
    H = holoCreate(I,E:toWorld(vec(I*3,0,0)),vec(0.2))
    holoModel(I,"hq_sphere")
    holoParent(I,E)    
    H:setTrails(5,0,1.5,"trails/laser",vec(0,155,255),255)
    if(I == 128){End = 1}
}
else
{
    Array = soundGetFFT(1)
    while(perf())
    {
        I++       
        Val =  sqrt(Array:number(I)*32*sqrt(I))*5
        HoloPos = E:toLocal(holoEntity(I):pos()):z()
        Pos = HoloPos+(Val-HoloPos)/10       
        holoPos(I,E:toWorld(vec(I*3,0,Pos)))
        
        if(I >= 128){I = 0}
    }
}
if(last())
{
    soundStopURL(1)
}
```
![SoundCore Circular visualizator0](http://puu.sh/ifUBw/498b7afeb1.jpg)
![SoundCore Circular visualizator1](http://puu.sh/ifUVW/aa219f6d03.jpg)

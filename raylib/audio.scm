(define-library
    (raylib audio)

  (import
   (owl core)
   (owl toplevel)
   (raylib common))

  (export
   init-audio-device
   close-audio-device
   audio-device-ready?
   set-master-volume!
   file->wave
   load-wave
   file->sound
   load-sound
   wave->sound
   unload-wave
   unload-sound
   wave->file
   play-sound
   pause-sound
   resume-sound
   stop-sound
   sound-playing?
   set-sound-volume!
   set-sound-pitch!
   format-wave!
   copy-wave
   crop-wave
   file->music-stream
   load-music-stream
   unload-music-stream
   play-music-stream
   update-music-stream
   stop-music-stream
   pause-music-stream
   resume-music-stream
   music-stream-playing?
   set-music-volume!
   set-music-pitch!
   music-time-length
   music-time-played

   list->music-stream
   list->wave
   bytevector->music-stream
   bytevector->wave
   )

  (begin
    (define (init-audio-device)       (prim 269))
    (define (close-audio-device)      (prim 270))
    (define (audio-device-ready?)     (prim 271))
    (define (set-master-volume! vol)  (prim 272 vol))

    (define (file->wave fname)       (prim 273 (c-string fname)))
    (define load-wave file->wave)
    (define (file->sound fname)      (prim 274 (c-string fname)))
    (define load-sound file->sound)
    (define (wave->sound wave)       (prim 275 wave))
    (define (unload-wave w)          (prim 276 w))
    (define (unload-sound s)         (prim 277 s))
    (define (wave->file wave fname)  (prim 278 wave (c-string fname)))

    (define (play-sound snd)              (prim 279 snd))
    (define (pause-sound snd)             (prim 280 snd))
    (define (resume-sound snd)            (prim 281 snd))
    (define (stop-sound snd)              (prim 282 snd))
    (define (sound-playing? snd)          (prim 283 snd))
    (define (set-sound-volume! snd vol)   (prim 284 snd vol))
    (define (set-sound-pitch! snd pitch)  (prim 285 snd pitch))
    (define (format-wave! wave sample-rate sample-size channels)
                                          (prim 286 wave sample-rate (list sample-size channels)))
    (define (copy-wave wave)              (prim 287 wave))
    (define (crop-wave wave init final)   (prim 288 wave init final))

    (define (file->music-stream fname)    (prim 289 (c-string fname)))
    (define load-music-stream file->music-stream)
    (define (unload-music-stream mus)     (prim 290 mus))
    (define (play-music-stream mus)       (prim 291 mus))
    (define (update-music-stream mus)     (prim 292 mus))
    (define (stop-music-stream mus)       (prim 293 mus))
    (define (pause-music-stream mus)      (prim 294 mus))
    (define (resume-music-stream mus)     (prim 295 mus))
    (define (music-stream-playing? mus)   (prim 296 mus))
    (define (set-music-volume! mus vol)   (prim 297 mus vol))
    (define (set-music-pitch! mus pitch)  (prim 298 mus pitch))
    (define (music-time-length mus)       (prim 299 mus))
    (define (music-time-played mus)       (prim 300 mus))

    (define (bytevector->music-stream type lst)
      (prim 301 (c-string type) (maybe-bytevectorize lst)))

    (define (bytevector->wave type lst)
      (prim 302 (c-string type) (maybe-bytevectorize lst)))

    (define list->music-stream bytevector->music-stream)
    (define list->wave bytevector->wave)

    ))

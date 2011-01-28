(load "bacon")

(class NSString
  (- (id)expandPath is
    (if (self isAbsolutePath)
      (then (self stringByStandardizingPath))
      (else (((NSFileManager defaultManager) currentDirectoryPath) stringByAppendingPathComponent:self))
    )
  )
)

(function specsFromCLIArguments ()
  (set specs (((NSProcessInfo processInfo) arguments) list))
  ; remove bin path and possibly -RegisterForSystemEvents
  (set specs (specs cdr))
  (if (eq (specs car) "-RegisterForSystemEvents") (then (set specs (specs cdr))))
  (specs map:(do (f) (f expandPath)))
)

(function loadSpecs ()
  (set specs (specsFromCLIArguments))
  (puts specs)
  (specs each:(do (spec) (load spec)))
  ;(load "UIImageCropSpec")
  ;(load "FTRotatingScrollViewSpec")
)

(class AppDelegate is NSObject
  (ivar (id) window (id) contentView (id) textField (id) label)

  (- (void)applicationDidFinishLaunching:(id)application is
    ;; Set up the window and content view
    (set screenRect ((UIScreen mainScreen) bounds))
    (set @window ((UIWindow alloc) initWithFrame:screenRect))

    (set @contentView ((UIView alloc) initWithFrame:screenRect))
    (@contentView setBackgroundColor:(UIColor scrollViewTexturedBackgroundColor))

    (@window addSubview:@contentView)

    ;; Show the window
    (@window makeKeyAndVisible)

    ;; Load and run the specs
    (loadSpecs)

    ;; Report
    ($BaconSummary print)

  (exit 0)
  )
)

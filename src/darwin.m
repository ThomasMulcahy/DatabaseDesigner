#include "database.h"
#import "platform.h"
#import "view.h"

#import <Cocoa/Cocoa.h>

@interface AppView : NSView <NSWindowDelegate>
{
	//TODO: Temp - Delete
	NSFont *font;
	View *view;
}
@end

@implementation AppView

	- (instancetype) initWithFrame:(NSRect)frameRect {
		[super initWithFrame:frameRect];

		view = onViewCreate();

		return self;
	}

    //Accept window events
    - (BOOL) acceptsFirstResponder {
        return YES;
    }

    - (void) windowWillClose:(NSNotification *)notification {
        [NSApp terminate:self];
    } 

    - (void) dealloc {  
	    [super dealloc];
    }  

	//TODO: Move to View for rendering!!!
	- (void) drawRect:(NSRect)rectToRedraw {
		//We should use attributed strings for rendering, this could help with formatting? Below is an example
		//NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Menlo" size:13], 
		//							  NSFontAttributeName,[NSColor whiteColor], 
		//							  NSForegroundColorAttributeName, nil];
		//NSAttributedString * currentText= [[NSAttributedString alloc] initWithString:@"Cat" attributes: attributes];
		//NSSize attrSize = [currentText size];
		//[currentText drawAtPoint:NSMakePoint(0, 0)];

		if (view == NULL)
			return;

		Database *db = view->db;
		if (db == NULL)
			return;

		Table *table = db->tables;
		if (table == NULL)
			return;

		while  (table != NULL) {
			if (table->tableName != NULL) {
				NSBezierPath *tableNameRect = [NSBezierPath bezierPathWithRect:NSMakeRect(table->xPos, table->yPos + table->height - 25, table->width, 25)];
				[[NSColor darkGrayColor] setStroke];
				[[NSColor lightGrayColor] setFill];
				[tableNameRect setLineWidth:2.0];
				[tableNameRect stroke];
				[tableNameRect fill];
			}

			NSBezierPath *tableRect = [NSBezierPath bezierPathWithRect:NSMakeRect(table->xPos, table->yPos, table->width, table->height)];
			[[NSColor darkGrayColor] setStroke];
			[tableRect setLineWidth:2.0];
			[tableRect stroke];

			table = table->nextTable;
		}
 	}

	//Events
	- (void) windowDidResize:(NSNotification*) notification {
		
	}

	- (void) mouseMoved:(NSEvent*) event {

	}

	- (void) mouseDragged: (NSEvent*) event {

	}

	- (void) scrollWheel: (NSEvent*) event  {

	}

	- (void) mouseDown: (NSEvent*) event {

	}

	- (void) mouseUp: (NSEvent*) event {
		NSPoint loc = [event locationInWindow];

		ViewEvent ve = {
			.eventKind = MOUSE_UP_EVENT,

			.mouseX = loc.x,
			.mouseY = loc.y 
		};

		onViewEvent(view, ve);
		[self setNeedsDisplay:YES];
	}

	- (void) rightMouseDown: (NSEvent*) event {

	}

	- (void) rightMouseUp: (NSEvent*) event {

	}

	- (void) otherMouseDown: (NSEvent*) event {

	}

	- (void) otherMouseUp: (NSEvent*) event {

	}

	- (void) mouseEntered: (NSEvent*)event {

	}

	- (void) mouseExited: (NSEvent*)event {

	}

	- (void) keyDown: (NSEvent*) event {
		NSString *chars = event.charactersIgnoringModifiers;
    	unichar aChar = [chars characterAtIndex: 0];

		ViewEvent ve = {
			.eventKind = KEY_DOWN_EVENT,
			.code = aChar
		};

		onViewEvent(view, ve);
		[self setNeedsDisplay:YES];
	}

	- (void) keyUp: (NSEvent*) event {

	}
@end

//Entry point for the Cocoa application.
int platformRun(WindowOpt *winOptions) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSApp = [NSApplication sharedApplication];

    //Create Cocoa window.
    NSRect frame = NSMakeRect(0, 0, winOptions->width, winOptions->height);
    NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable; 
    NSRect screenRect = [[NSScreen mainScreen] frame];
	NSRect viewRect = NSMakeRect(0, 0, winOptions->width, winOptions->height); 
	NSRect windowRect = NSMakeRect(NSMidX(screenRect) - NSMidX(viewRect),
								 NSMidY(screenRect) - NSMidY(viewRect),
								 viewRect.size.width, 
								 viewRect.size.height);

	NSWindow * window = [[NSWindow alloc] initWithContentRect:windowRect 
						styleMask:style 
						backing:NSBackingStoreBuffered 
						defer:NO]; 

	//Window controller 
	NSWindowController * windowController = [[NSWindowController alloc] initWithWindow:window]; 
	[windowController autorelease];

    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

    //Create menu bar - we require this as from Snow Leopard this is not given to us.
	id menubar = [[NSMenu new] autorelease];
	id appMenuItem = [[NSMenuItem new] autorelease];
	[menubar addItem:appMenuItem];
	[NSApp setMainMenu:menubar];

	id appMenu = [[NSMenu new] autorelease];
	id quitTitle = [@"Quit " stringByAppendingString:[NSString stringWithCString:winOptions->title encoding:NSASCIIStringEncoding]];
	id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:quitTitle
		                                   action:@selector(terminate:) 
                                           keyEquivalent:@"q"] autorelease];
	[appMenu addItem:quitMenuItem];
	[appMenuItem setSubmenu:appMenu];

    //Create app delegate to handle system events
	AppView* view = [[[AppView alloc] initWithFrame:frame] autorelease];
	[window setAcceptsMouseMovedEvents:YES];
	[window setContentView:view];
	[window setDelegate:view];

	[window setContentView:view];
	[window makeFirstResponder:view];

	//Set app title
	[window setTitle:[NSString stringWithCString:winOptions->title encoding:NSASCIIStringEncoding]];

	//Add fullscreen button
	[window setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary];

	//Show window and run event loop 
	[window orderFrontRegardless];

	[[NSApp mainWindow] makeKeyWindow];
    [NSApp run];
    //We reach here when the application is closed
    [pool drain];
    return(EXIT_SUCCESS);
}
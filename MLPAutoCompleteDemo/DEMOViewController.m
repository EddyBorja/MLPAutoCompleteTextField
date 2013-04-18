//
//  MLPViewController.m
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 1/23/13.
//  Copyright (c) 2013 Mainloop. All rights reserved.
//

#import "DEMOViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "DEMOCustomAutoCompleteCell.h"
#import <QuartzCore/QuartzCore.h>

@interface DEMOViewController ()


@end

@implementation DEMOViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setAlpha:0];
    [UIView animateWithDuration:0.2
                          delay:0.25
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self.view setAlpha:1.0];
                     }completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self setSimulateLatency:YES]; //Uncomment to delay the return of autocomplete suggestions.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    //Supported Styles:
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleBezel];
    //TODO[self.autocompleteTextField setBorderStyle:UITextBorderStyleLine];
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleNone];
    [self.autocompleteTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    
    //You can use custom TableViewCell classes and nibs in the autocomplete tableview if you wish.
    [self.autocompleteTextField registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class]
                                       forCellReuseIdentifier:@"CustomCellId"];
    
}



- (void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, -60);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                         [self.author setAlpha:0];
                         [self.demoTitle setAlpha:0];
                         
                     }
                     completion:nil];
}


- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, 60);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                         [self.author setAlpha:1];
                         [self.demoTitle setAlpha:1];
                     }
                     completion:nil];
    
    
    [self.autocompleteTextField setAutoCompleteTableViewHidden:NO];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MLPAutoCompleteTextField DataSource

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField                     possibleCompletionsForString:(NSString *)string
{
    
    if(self.simulateLatency){
        CGFloat seconds = arc4random_uniform(4);
        NSLog(@"sleeping fetch of completions for %f", seconds);
        sleep(seconds);
    }
    
    NSArray *countries =
    @[
      @"Abkhazia",
      @"Afghanistan",
      @"Aland",
      @"Albania",
      @"Algeria",
      @"American Samoa",
      @"Andorra",
      @"Angola",
      @"Anguilla",
      @"Antarctica",
      @"Antigua & Barbuda",
      @"Argentina",
      @"Armenia",
      @"Aruba",
      @"Australia",
      @"Austria",
      @"Azerbaijan",
      @"Bahamas",
      @"Bahrain",
      @"Bangladesh",
      @"Barbados",
      @"Belarus",
      @"Belgium",
      @"Belize",
      @"Benin",
      @"Bermuda",
      @"Bhutan",
      @"Bolivia",
      @"Bosnia & Herzegovina",
      @"Botswana",
      @"Brazil",
      @"British Antarctic Territory",
      @"British Virgin Islands",
      @"Brunei",
      @"Bulgaria",
      @"Burkina Faso",
      @"Burundi",
      @"Cambodia",
      @"Cameroon",
      @"Canada",
      @"Cape Verde",
      @"Cayman Islands",
      @"Central African Republic",
      @"Chad",
      @"Chile",
      @"China",
      @"Christmas Island",
      @"Cocos Keeling Islands",
      @"Colombia",
      @"Commonwealth",
      @"Comoros",
      @"Cook Islands",
      @"Costa Rica",
      @"Cote d'Ivoire",
      @"Croatia",
      @"Cuba",
      @"Cyprus",
      @"Czech Republic",
      @"Democratic Republic of the Congo",
      @"Denmark",
      @"Djibouti",
      @"Dominica",
      @"Dominican Republic",
      @"East Timor",
      @"Ecuador",
      @"Egypt",
      @"El Salvador",
      @"England",
      @"Equatorial Guinea",
      @"Eritrea",
      @"Estonia",
      @"Ethiopia",
      @"European Union",
      @"Falkland Islands",
      @"Faroes",
      @"Fiji",
      @"Finland",
      @"France",
      @"Gabon",
      @"Gambia",
      @"Georgia",
      @"Germany",
      @"Ghana",
      @"Gibraltar",
      @"GoSquared",
      @"Greece",
      @"Greenland",
      @"Grenada",
      @"Guam",
      @"Guatemala",
      @"Guernsey",
      @"Guinea Bissau",
      @"Guinea",
      @"Guyana",
      @"Haiti",
      @"Honduras",
      @"Hong Kong",
      @"Hungary",
      @"Iceland",
      @"India",
      @"Indonesia",
      @"Iran",
      @"Iraq",
      @"Ireland",
      @"Isle of Man",
      @"Israel",
      @"Italy",
      @"Jamaica",
      @"Japan",
      @"Jersey",
      @"Jordan",
      @"Kazakhstan",
      @"Kenya",
      @"Kiribati",
      @"Kosovo",
      @"Kuwait",
      @"Kyrgyzstan",
      @"Laos",
      @"Latvia",
      @"Lebanon",
      @"Lesotho",
      @"Liberia",
      @"Libya",
      @"Liechtenstein",
      @"Lithuania",
      @"Luxembourg",
      @"Macau",
      @"Macedonia",
      @"Madagascar",
      @"Malawi",
      @"Malaysia",
      @"Maldives",
      @"Mali",
      @"Malta",
      @"Mars",
      @"Marshall Islands",
      @"Mauritania",
      @"Mauritius",
      @"Mayotte",
      @"Mexico",
      @"Micronesia",
      @"Moldova",
      @"Monaco",
      @"Mongolia",
      @"Montenegro",
      @"Montserrat",
      @"Morocco",
      @"Mozambique",
      @"Myanmar",
      @"Nagorno Karabakh",
      @"Namibia",
      @"NATO",
      @"Nauru",
      @"Nepal",
      @"Netherlands Antilles",
      @"Netherlands",
      @"New Caledonia",
      @"New Zealand",
      @"Nicaragua",
      @"Niger",
      @"Nigeria",
      @"Niue",
      @"Norfolk Island",
      @"North Korea",
      @"Northern Cyprus",
      @"Northern Mariana Islands",
      @"Norway",
      @"Olympics",
      @"Oman",
      @"Pakistan",
      @"Palau",
      @"Palestine",
      @"Panama",
      @"Papua New Guinea",
      @"Paraguay",
      @"Peru",
      @"Philippines",
      @"Pitcairn Islands",
      @"Poland",
      @"Portugal",
      @"Puerto Rico",
      @"Qatar",
      @"Red Cross",
      @"Republic of the Congo",
      @"Romania",
      @"Russia",
      @"Rwanda",
      @"Saint Barthelemy",
      @"Saint Helena",
      @"Saint Kitts & Nevis",
      @"Saint Lucia",
      @"Saint Vincent & the Grenadines",
      @"Samoa",
      @"San Marino",
      @"Sao Tome & Principe",
      @"Saudi Arabia",
      @"Scotland",
      @"Senegal",
      @"Serbia",
      @"Seychelles",
      @"Sierra Leone",
      @"Singapore",
      @"Slovakia",
      @"Slovenia",
      @"Solomon Islands",
      @"Somalia",
      @"Somaliland",
      @"South Africa",
      @"South Georgia & the South Sandwich Islands",
      @"South Korea",
      @"South Ossetia",
      @"South Sudan",
      @"Spain",
      @"Sri Lanka",
      @"Sudan",
      @"Suriname",
      @"Swaziland",
      @"Sweden",
      @"Switzerland",
      @"Syria",
      @"Taiwan",
      @"Tajikistan",
      @"Tanzania",
      @"Thailand",
      @"Togo",
      @"Tonga",
      @"Trinidad & Tobago",
      @"Tunisia",
      @"Turkey",
      @"Turkmenistan",
      @"Turks & Caicos Islands",
      @"Tuvalu",
      @"Uganda",
      @"Ukraine",
      @"United Arab Emirates",
      @"United Kingdom",
      @"United Nations",
      @"United States",
      @"Uruguay",
      @"US Virgin Islands",
      @"Uzbekistan",
      @"Vanuatu",
      @"Vatican City",
      @"Venezuela",
      @"Vietnam",
      @"Wales",
      @"Western Sahara",
      @"Yemen",
      @"Zambia",
      @"Zimbabwe"
    ];

    return countries;
}


#pragma mark - MLPAutoCompleteTextField Delegate


- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    [cell.imageView setImage:[UIImage imageNamed:filename]];
    
    return YES;
}



@end

library(shiny)


drg.codes = c("057", "064", "065", "066", "069", "101", "176", "177", "178", "189", "190", "191", "192", "193", "194",
              "195", "202", "203", "208", "243", "280", "281", "282", "291", "292", "293", "300", "305", "308", "309",
              "310", "312", "313", "329", "330", "372", "377", "378", "379", "389", "390", "391", "392", "394", "419",
              "470", "481", "482", "536", "552", "563", "603", "637", "638", "640", "641", "682", "683", "684", "689",
              "690", "811", "812", "853", "871", "872", "897", "918", "948", "149", "207", "303", "314", "315", "331",
              "439", "460", "698", "699", "917", "074", "244", "253", "287", "469", "473", "480", "491", "602", "039",
              "100", "238", "246", "247", "249", "251", "252", "254", "286", "301", "371", "418", "467", "484", "870",
              "885")

states = list( 
  'Alaska'=                  'AK', 
  'Alabama'=                 'AL', 
  'Arkansas'=                'AR', 
  'American Samoa'=          'AS', 
  'Arizona'=                 'AZ', 
  'California'=              'CA', 
  'Colorado'=                'CO', 
  'Connecticut'=             'CT', 
  'District of Columbia'=    'DC', 
  'Delaware'=                'DE', 
  'Florida'=                 'FL', 
  'Georgia'=                 'GA', 
  'Guam'=                    'GU', 
  'Hawaii'=                  'HI', 
  'Iowa'=                    'IA', 
  'Idaho'=                   'ID', 
  'Illinois'=                'IL', 
  'Indiana'=                 'IN', 
  'Kansas'=                  'KS', 
  'Kentucky'=                'KY', 
  'Louisiana'=               'LA', 
  'Massachusetts'=           'MA', 
  'Maryland'=                'MD', 
  'Maine'=                   'ME', 
  'Michigan'=                'MI', 
  'Minnesota'=               'MN', 
  'Missouri'=                'MO', 
  'Northern Mariana Islands'='MP', 
  'Mississippi'=             'MS', 
  'Montana'=                 'MT', 
  'National'=                'NA', 
  'North Carolina'=          'NC', 
  'North Dakota'=            'ND', 
  'Nebraska'=                'NE', 
  'New Hampshire'=           'NH', 
  'New Jersey'=              'NJ', 
  'New Mexico'=              'NM', 
  'Nevada'=                  'NV', 
  'New York'=                'NY', 
  'Ohio'=                    'OH', 
  'Oklahoma'=                'OK', 
  'Oregon'=                  'OR', 
  'Pennsylvania'=            'PA', 
  'Puerto Rico'=             'PR', 
  'Rhode Island'=            'RI', 
  'South Carolina'=          'SC', 
  'South Dakota'=            'SD', 
  'Tennessee'=               'TN', 
  'Texas'=                   'TX', 
  'Utah'=                    'UT', 
  'Virginia'=                'VA', 
  'Virgin Islands'=          'VI', 
  'Vermont'=                 'VT', 
  'Washington'=              'WA', 
  'Wisconsin'=               'WI', 
  'West Virginia'=           'WV', 
  'Wyoming'=                  'WY'
)

shinyUI(
  verticalLayout(
    
    # Application title
    headerPanel("hi friends"),
    
    sidebarPanel(
      selectInput("statename", "State:", states),
      selectInput("drgcode", "code:", drg.codes)
    ),
    
    mainPanel(
        plotOutput("ggPlot")
    )
    
  )
)

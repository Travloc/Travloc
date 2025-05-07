# 🌍 Travloc UI/UX Documentation

## 🚨 Legacy UI Modernization Checklist (Agentic Refactor)

- [x] Conflict Resolution UI (`lib/core/widgets/conflict_resolution_ui.dart`)
  - Refactored to use PreferenceTile, pastel backgrounds, theme-based colors, and AppButton. Legacy widgets and direct color usage removed.
- [ ] Offline Support UI (`lib/core/widgets/offline_support_ui.dart`)
  - Uses: `ListTile`, `AlertDialog`, legacy Card, direct color usage
- [ ] Security Screen (`lib/features/profile/presentation/screens/security_screen.dart`)
  - Uses: `ListTile`, `AlertDialog`, direct color usage, legacy paddings

---

## 📋 Implementation Checklist

### Phase 1: Core Features (MVP)
- [x] Basic UI Framework
  - [x] Core Design Principles
  - [x] Basic Color Scheme
  - [x] Essential Typography
  - [x] Basic Component Library
  - [x] Simple Animations

- [x] Essential Screens
  - [x] Basic Home Screen
  - [x] Simple Trip Planner
  - [x] Basic Profile View
  - [x] Simple Guide List
  - [x] Basic Messaging Interface

- [x] Basic User Flows
  - [x] Simple Onboarding
  - [x] Basic Trip Creation
  - [x] Simple Guide Search
  - [x] Basic Messaging
  - [x] Profile Setup

### Phase 2: Enhanced Features
- [x] Advanced UI Components
  - [x] Enhanced Component Library
  - [x] Advanced Animations
  - [x] Responsive Design
  - [x] Dark Mode
  - [x] Custom Icons

- [x] Core Functionality
  - [x] Interest Selection System
  - [x] Timeline Management
  - [x] Basic AI Suggestions
  - [x] Simple Package System
  - [x] Basic Search & Filters

- [x] User Experience
  - [x] Loading States
  - [x] Error Handling
  - [x] Success Feedback
  - [x] Basic Offline Support
  - [x] Simple Sync System

### Phase 3: AI & Voice Integration
- [x] AI Integration UI
  - [x] Basic Voice Input UI
  - [x] Simple AI Suggestions UI
  - [x] Basic Trip Planning UI
  - [x] Simple Feedback UI

- [x] Advanced AI UI Features
  - [x] Advanced Voice Input UI
    - [x] Enhanced voice recognition
    - [x] Visual feedback for states
    - [x] Wave animation during listening
    - [x] Error handling and recovery
    - [x] Voice command hints
  - [x] Advanced Feedback UI
    - [x] Rating system with stars
    - [x] Tag-based feedback
    - [x] Comment section
    - [x] Success/error notifications
    - [x] Context-aware prompts
  - [x] UI Interaction States
    - [x] Idle state
    - [x] Listening state
    - [x] Processing state
    - [x] Success state
    - [x] Error state

### Phase 4: Security & Safety
- [x] Authentication & Security UI
  - [x] User Authentication Screens
  - [x] Security Settings UI
  - [x] Profile Verification UI
    - [x] Document upload interface
    - [x] Verification status display
    - [x] Document type selection
    - [x] Upload progress tracking
    - [x] Error handling
    - [x] Success feedback
  - [x] Guide Verification UI
  - [x] Trust System UI

- [x] Advanced Safety UI Features
  - [x] Emergency Response UI Components
    - [x] SOS button with animation
    - [x] Location sharing toggle
    - [x] Emergency contacts list
    - [x] Quick action buttons
    - [x] Status indicators
  - [x] Location Safety UI Components
    - [x] Safe zone indicators
    - [x] Risk level warnings
    - [x] Current zone status
    - [x] Nearby safe zones
    - [x] Warning list
  - [x] Personal Safety UI Components
    - [x] Trust score display
    - [x] Verification status
    - [x] Safety guidelines
    - [x] Action items
    - [x] Progress tracking
  - [x] Guide Safety UI Components
    - [x] Verification badges
    - [x] Safety training status
    - [x] Equipment checklist
    - [x] Emergency protocols
    - [x] Certification display

### Phase 5: Feature Implementation (Current Focus)
- [ ] Core Screens Implementation
  - [ ] Home/Explore Screen
  - [ ] AI Trip Planner Card
  - [ ] Interactive Map
  - [ ] Next Event Card

  - [ ] Trip Planner Screen
- [ ] Tab Navigation
- [ ] Interest Selection
- [ ] Timeline Tab
- [ ] Suggestions Tab
- [ ] Packages Tab

  - [ ] Guide Marketplace
- [ ] View Options
- [ ] Filter System
- [ ] Guide Cards
- [ ] Travel Buddy Cards

  - [ ] Messaging System
- [ ] Tab Navigation
- [ ] Guides Tab
- [ ] Travel Buddies Tab
- [ ] Support Tab
- [ ] Common Features

  - [ ] Profile Section
- [ ] User Information
- [ ] Identity Verification
- [ ] Safety & Emergency
- [ ] Verification & Trust
- [ ] Dispute Resolution
- [ ] Quick Access

### Phase 6: Performance & Optimization
- [ ] Performance Optimization
  - [ ] Loading Optimization
- [ ] Lazy loading
- [ ] Progressive loading
- [ ] Cached data
- [ ] Data prefetching
  - [ ] Resource Management
- [ ] Battery optimization
- [ ] Data usage
- [ ] Storage management
- [ ] Cache control
  - [ ] Background Processes
- [ ] Update management
    - [ ] Sync management
    - [ ] Background tasks

- [ ] User Experience Enhancement
  - [ ] Accessibility Features
    - [ ] Voice commands
    - [ ] High contrast mode
    - [ ] Text scaling
    - [ ] Screen reader support
    - [ ] Gesture alternatives
    - [ ] Multilingual support
  - [ ] Sync Status Indicators
    - [ ] Online State
    - [ ] Syncing State
    - [ ] Offline State
    - [ ] Error State
  - [ ] Offline Support
    - [ ] Map Features
    - [ ] Trip Planning
    - [ ] User Data
    - [ ] Offline Data UI
  - [ ] Conflict Resolution
    - [ ] Detection System
    - [ ] Resolution Interface
    - [ ] Feedback System

- [ ] AI Translation Widget
- [ ] Widget Features
    - [ ] Language pair selection
    - [ ] Text input/output
    - [ ] Voice input/output
    - [ ] Quick translate button
    - [ ] History of translations
    - [ ] Favorite translations
    - [ ] Offline mode support
- [ ] Translation Options
    - [ ] Menu translation
    - [ ] Sign translation
    - [ ] Document translation
    - [ ] Cultural context notes
    - [ ] Translation history
- [ ] Widget Settings
    - [ ] Language preferences
    - [ ] Voice settings
    - [ ] Text size
    - [ ] Theme options
    - [ ] Widget size
    - [ ] Position options

- [ ] Development Guidelines
- [ ] Code Structure
    - [ ] Component organization
    - [ ] State management
    - [ ] API integration
    - [ ] Error handling
    - [ ] Performance monitoring
    - [ ] Testing strategy
- [ ] Asset Management
    - [ ] Image optimization
    - [ ] Icon system
    - [ ] Font management
    - [ ] Animation assets
    - [ ] Sound effects
    - [ ] Video content

### Phase 7: Design Enhancement (Future)
- [ ] Material Design 3 Implementation
- [ ] Visual Design System
  - [ ] Color Palette
  - [ ] Typography
  - [ ] Component Specifications
  - [ ] Icon System
  - [ ] Spacing System
  - [ ] Animation Specifications
- [ ] Advanced UI Components
- [ ] Custom Animations
- [ ] Enhanced Visual Feedback
- [ ] Premium UI Features

### Phase 8: Mapbox Integration (Backend Focus)
- [ ] Map & Location Features
  - [ ] Basic Map View
    - [ ] Simple map display
    - [ ] Basic location markers
    - [ ] Current location indicator
    - [ ] Basic zoom controls
    - [ ] Simple search functionality

  - [ ] Location Features
    - [ ] Current location tracking
    - [ ] Location search
    - [ ] Place markers
    - [ ] Basic navigation
    - [ ] Location sharing
    - [ ] Safe zone indicators
    - [ ] Offline location support
- [ ] Mapbox Core Integration
  - [ ] API Integration
  - [ ] Authentication Setup
  - [ ] Service Configuration
  - [ ] Error Handling
  - [ ] Rate Limiting
  - [ ] Cache Management

- [ ] Advanced Map Features
  - [ ] Mapbox UI Integration
  - [ ] Custom map style implementation
  - [ ] 3D buildings and terrain
  - [ ] Advanced POI markers
  - [ ] Custom overlays
  - [ ] Route optimization
  - [ ] Geocoding services
  - [ ] Reverse geocoding
  - [ ] Batch geocoding

- [ ] Offline Map Support
  - [ ] Map tile caching
  - [ ] Offline region management
  - [ ] Storage optimization
  - [ ] Background downloads
  - [ ] Update management
  - [ ] Cache cleanup

- [ ] Location Services
  - [ ] Real-time location tracking
  - [ ] Geofencing implementation
  - [ ] Location history
  - [ ] Location analytics
  - [ ] Battery optimization
  - [ ] Privacy controls

- [ ] Security & Privacy
  - [ ] Location data encryption
  - [ ] User consent management
  - [ ] Data retention policies
  - [ ] Privacy controls
  - [ ] Compliance checks
  - [ ] Audit logging

### Phase 9: Analytics & Monitoring
- [ ] User Analytics
  - [ ] Feature usage tracking
  - [ ] User behavior analysis
  - [ ] Conversion tracking
  - [ ] Retention metrics
  - [ ] Error tracking

- [ ] Performance Monitoring
  - [ ] Load times
  - [ ] Response times
  - [ ] Error rates
  - [ ] Resource usage
  - [ ] Network performance
  - [ ] Battery impact

- [ ] Update & Maintenance
  - [ ] Version Control
  - [ ] Content Management
  - [ ] Feature flags
  - [ ] A/B testing
  - [ ] Rollback procedures
  - [ ] Update notifications

## 📝 Detailed Specifications

## 1. 🎨 Design Foundation

### Core Design Principles
- Material Design 3 implementation
- Clean, minimalist interface
- Consistent color scheme
- Clear typography hierarchy
- Intuitive icons
- Smooth transitions
- Responsive feedback
- Clear call-to-actions

### Map Implementation
- **Mapbox Integration**
  - Custom map style
  - 3D buildings and terrain
  - POI markers and clusters
  - Current trip overlay
  - Focus mode for nearby attractions
  - Orientation compass
  - Return to location button
  - Safe zone indicators
  - Smart preloading

### AI Integration
```typescript
interface AIInteraction {
  // Voice Input
  voiceInput: {
    activation: 'tap',
    timeout: 5000,
    feedback: {
      listening: boolean,
      processing: boolean,
      success: boolean,
      error: boolean
    }
  },

  // Trip Planning
  tripPlanning: {
    input: {
      destination: string,
      dates: string,
      preferences: string[]
    },
    output: {
      itinerary: Itinerary,
      suggestions: Suggestion[]
    },
    feedback: {
      accuracy: number,
      relevance: number,
      userRating: number
    }
  },

  // Interaction States
  states: {
    idle: {
      visual: 'microphone icon',
      audio: 'none'
    },
    listening: {
      visual: 'wave animation',
      audio: 'beep'
    },
    processing: {
      visual: 'loading spinner',
      audio: 'none'
    },
    success: {
      visual: 'check mark',
      audio: 'success tone'
    },
    error: {
      visual: 'error icon',
      audio: 'error tone'
    }
  }
}
```

### Visual Design System
- **Color Palette**
  - Primary Colors
    - Primary: #2196F3
    - Primary Dark: #1976D2
    - Primary Light: #BBDEFB
    - Accent: #FF4081
    - Accent Dark: #F50057
    - Accent Light: #FF80AB
  
  - Secondary Colors
    - Success: #4CAF50
    - Warning: #FFC107
    - Error: #F44336
    - Info: #2196F3
  
  - Background Colors
    - Surface: #FFFFFF
    - Background: #F5F5F5
    - Card: #FFFFFF
    - Dialog: #FFFFFF
  
  - Text Colors
    - Primary Text: #212121
    - Secondary Text: #757575
    - Disabled Text: #9E9E9E
    - Hint Text: #9E9E9E

- **Typography**
  - Font Family: Roboto
  - Scale System
- [ ] Component Specifications
  - Buttons
  - Cards
  - Input Fields
  - Lists
  - Modals
- [ ] Icon System
- [ ] Spacing System
- [ ] Animation Specifications

### Accessibility
- Voice commands throughout the app
- High contrast mode
- Text scaling
- Screen reader support
- Gesture alternatives
- Multilingual support

### Sync Status Indicators
- **Online State**
  - Subtle checkmark icon in status bar
  - Green dot indicator
  - "All changes saved" tooltip
  - Smooth transitions

- **Syncing State**
  - Animated circular progress indicator
  - "Syncing changes..." message
  - Progress percentage when applicable
  - Non-blocking UI updates

- **Offline State**
  - Orange warning icon in status bar
  - "Working offline" message
  - Last synced timestamp
  - Queued changes count
  - Auto-sync when back online

- **Error State**
  - Red error icon in status bar
  - Clear error message
  - Retry button
  - Error details in tooltip
  - Conflict resolution UI

### Offline Support
- **Map Features**
  - Offline map downloads
  - Cached POI data
  - Saved locations
  - Offline navigation
  - Download progress indicators
  - Storage management
  - Auto-sync when online

- **Trip Planning**
  - Offline itinerary access
  - Cached packing lists
  - Saved guide information
  - Local emergency contacts
  - Offline translations
  - Sync status indicators
  - Background sync

- **User Data**
  - Profile information
  - Saved preferences
  - Bookmarked locations
  - Recent searches
  - Travel history
  - Auto-sync preferences

  - **Offline Data UI**
    - Data status indicators
    - Sync queue visualization
    - Manual sync controls
    - Storage management
    - Conflict resolution
    - Last synced timestamp
    - Pending changes count

### Conflict Resolution UI
- **Detection**
  - Visual conflict indicators
  - Conflict type badges
  - Affected data preview
  - Timestamp comparison
  - Change history view

- **Resolution**
  - Side-by-side comparison
  - Version selection
  - Merge options
  - Custom resolution
  - Resolution history
  - Undo capability
  - Resolution preferences

- **Feedback**
  - Resolution confirmation
  - Success indicators
  - Error handling
  - Resolution history
  - User preferences
  - Auto-resolution options
  - Manual override

### Performance Optimization
- **Loading States**
  - Skeleton screens
  - Progressive loading
  - Lazy loading
  - Placeholder content
  - Loading animations
  - Error states
  - Retry options

- **Resource Management**
  - Image optimization
  - Cache control
  - Memory management
  - Battery optimization
  - Data usage control
  - Storage optimization
  - Background processes

- **Responsive Design**
  - Adaptive layouts
  - Dynamic scaling
  - Orientation support
  - Screen size adaptation
  - Touch targets
  - Gesture optimization
  - Animation performance

### Enhanced Safety Features
- **Emergency Response**
  - One-tap emergency button
  - Location sharing
  - Emergency contacts
  - Local emergency numbers
  - Safety check-ins
  - SOS mode
  - Emergency guides

- **Location Safety**
  - Safe zone indicators
  - Risk level warnings
  - Crowd density alerts
  - Weather warnings
  - Traffic alerts
  - Security alerts
  - Health advisories

- **Personal Safety**
  - Trust score system
  - ID verification
  - Background checks
  - Report system
  - Block features
  - Privacy controls
  - Safety guidelines

- **Guide Safety**
  - Guide verification
  - Rating system
  - Review moderation
  - Safety training
  - Emergency protocols
  - Insurance verification
  - Equipment checks

## 2. 🎯 Navigation & Structure

### Main Navigation Bar
1. **Home/Explore**
   - Map-centric view
   - Quick actions
   - Discover features

2. **Trip Planner**
   - AI & Manual planning
   - Timeline view
   - Packing lists

3. **Guides**
   - **Guides Tab**
     - Marketplace
     - Search & filters
     - Booking system
     - Guide profiles
     - Specializations
     - Availability
     - Ratings & reviews
   
   - **Travel Buddies Tab**
     - Buddy matching
     - Travel interests
     - Destination matching
     - Date matching
     - Verification system
     - Trust building
     - Group coordination

4. **Messages**
   - Communication hub
   - Group chats
   - Notifications

5. **Profile**
   - User settings
   - Preferences
   - History

### Mobile-Specific Features
- **Gestures**
  - Swipe actions
  - Pull to refresh
  - Pinch to zoom
  - Long press
  - Double tap
  - Drag and drop

- **Device Integration**
  - Camera access
  - Location services
  - Push notifications
  - Haptic feedback
  - Voice input
  - Offline mode

## 3. 🏠 Core Screens

### Home/Explore Screen
- **Top Section (20%)**
  - AI Trip Planner Card
    - **Voice Interaction Mode**
      - Large microphone icon (48px) centered
      - Subtle pulse animation (2s duration, 1.2 scale)
      - "Speak to plan" hint text below icon
      - Voice wave animation during listening (3 bars, 0.5s animation)
      - Quick cancel button (X) in top-right
      - First-time user tooltip (appears once)
      - AI capabilities preview in bottom-right
      - Voice command hints in bottom-left
      - Background: Surface color with 1dp elevation
      - Transition to manual: Smooth slide-up animation (300ms)

    - **Manual Search Mode**
      - Toggle switch in top-right (Material Design switch)
      - Search bar expands from center (300ms animation)
      - Filters appear in sequence (100ms delay between each)
      - Map view adjusts height smoothly
      - Search history appears in dropdown
      - Recent searches with timestamps
      - Popular destinations with icons
      - Location type filters as chips
      - Date picker with calendar view
      - Budget slider with currency selector
      - Interest selection as expandable chips
      - Additional filters in collapsible section

    - **Transition Behavior**
      - AI to Manual:
        1. Microphone icon fades out (200ms)
        2. Search bar slides up from center (300ms)
        3. Filters fade in sequence (100ms each)
        4. Map view adjusts height (300ms)
      
      - Manual to AI:
        1. Search bar collapses to center (300ms)
        2. Filters fade out in reverse (100ms each)
        3. Microphone icon fades in (200ms)
        4. Map view returns to original height (300ms)

    - **Error States**
      - Voice recognition error: Red pulse animation
      - Network error: Yellow warning icon
      - Invalid input: Red border with helper text
      - Loading state: Circular progress indicator

    - **Success States**
      - Voice recognition success: Green check animation
      - Search results: Smooth expansion
      - Filter application: Subtle highlight
      - Save success: Brief confirmation toast

- **Middle Section (60%)**
  - Full-screen interactive map
    - Fixed position
    - No scrolling
    - Custom Mapbox implementation
    - 3D buildings and terrain
    - POI markers and clusters
    - Current trip overlay (when active)
    - Visual cues for interactive areas
    - Focus mode for nearby attractions
    - Orientation compass
    - Return to location button
    - Safe zone indicators
    - Smart preloading for common areas

- **Bottom Section (20%)**
  - Next Event Card
    - Upcoming activity details
    - Time remaining
    - Location
    - Transportation info
    - Quick navigation
    - Weather update
    - Guide availability
    - Smart notifications
    - Quick guide match
    - Visual countdown

### Trip Planner Screen
- **Tab Navigation**
  - Timeline Tab
  - Suggestions Tab
  - Packages Tab

- **Interest Selection (New Section)**
  - **Primary Interest Categories**
    - Adventure & Exploration
    - Nature & Scenery
    - Cultural & Historical
    - Relaxation & Wellness
    - Food & Culinary
    - Shopping & Markets
    - Nightlife & Entertainment
    - Sports & Activities

  - **Selection Interface**
    - Multi-select chip group
    - Visual icons for each category
    - Color-coded categories
    - Expandable descriptions
    - Popular combinations
    - Custom interest input
    - Interest strength slider
    - Recent selections
    - AI suggestions based on history

  - **Selection Flow**
    1. Initial selection screen
    2. Category expansion
    3. Sub-category selection
    4. Custom input option
    5. Strength adjustment
    6. Preview and edit
    7. Save preferences

  - **Visual Feedback**
    - Selected state animation
    - Category highlighting
    - Strength indicator
    - Selection count
    - AI recommendations
    - Popular combinations
    - Recent selections

  - **Integration Points**
    - Trip planning suggestions
    - Guide matching
    - Activity recommendations
    - Packing list generation
    - Destination suggestions
    - Weather considerations
    - Local event matching

- **Timeline Tab**
  - **Budget Summary (Top)**
    - Total estimated cost
    - Category-wise breakdown
    - Daily budget allocation
    - Cost comparison with average
    - Budget adjustment options
    - Visual budget progress indicators
    - Smart budget alerts
    - Quick budget adjustments
    - Budget optimization suggestions
    - Expense tracking

  - **Timeline View**
    - Day-by-day breakdown
    - Quick view mode
    - Focus mode for current day
    - Smart scroll to current time
    - Activity cards with:
      - Activity name and time
      - Location
      - Individual cost
      - Booking status
      - Guide/buddy integration
      - Quick actions
      - Time-sensitive indicators
      - Visual progress tracking
      - Smart loading states

    - **Packing Suggestions Button**
      - Floating action button (FAB) in bottom-right corner
      - Smart suitcase icon with dynamic content indicator
      - Subtle pulse animation when new suggestions available
      - Quick access to packing list
      - Weather-based packing recommendations
      - Activity-specific item suggestions
      - Smart categorization of items
      - Checklist functionality
      - Share packing list option
      - Offline access to packing list

  - **Next Event Card (Bottom)**
    - Upcoming activity details
    - Time remaining
    - Location
    - Transportation info
    - Quick navigation
    - Weather update
    - Guide availability
    - Smart notifications
    - Quick guide match
    - Visual countdown

- **Suggestions Tab**
  - **AI Nearby Suggestions**
    - Clean, modern design
    - Single tap to access suggestions
    - Quick add to timeline
    - Cost estimation
    - Popularity indicators
    - Weather-aware suggestions
    - Time-based recommendations
    - AI-powered indicator
    - Suggestion type preview
    - New suggestions animation

  - **Popular Destinations**
    - Trending locations
    - Seasonal highlights
    - Local favorites
    - Hidden gems
    - Quick preview
    - Add to wishlist
    - Share options
    - Cost indicators

  - **Trending Activities**
    - Popular experiences
    - Local events
    - Cultural activities
    - Adventure sports
    - Food experiences
    - Quick booking
    - Price range
    - Availability status

  - **Personalized Recommendations**
    - Based on preferences
    - Past trips
    - Saved interests
    - Budget range
    - Time constraints
    - Weather conditions
    - Local events
    - Special occasions

- **Packages Tab**
  - **Pre-made Itineraries**
    - Theme-based packages
    - Duration options
    - Price ranges
    - Difficulty levels
    - Group size options
    - Quick preview
    - Customization options
    - Booking availability

  - **Theme-based Packages**
    - Adventure packages
    - Cultural tours
    - Food & wine
    - Wellness retreats
    - Family packages
    - Solo traveler options
    - Luxury experiences
    - Budget-friendly options

  - **Seasonal Offers**
    - Current season deals
    - Upcoming season previews
    - Special discounts
    - Limited-time offers
    - Early bird rates
    - Last-minute deals
    - Package comparisons
    - Booking deadlines

  - **Special Deals**
    - Flash sales
    - Bundle offers
    - Group discounts
    - Loyalty rewards
    - Referral bonuses
    - Holiday specials
    - Anniversary packages
    - Custom deals

### Guide Marketplace
- **View Options**
  - Grid/List view toggle
  - Category view
  - Specialization view

- **Filter System**
  - Guide categories
  - Languages
  - Specializations
  - Price ranges
  - Availability
  - Ratings

- **Guide Cards**
  - Profile picture
  - Rating (1-5 stars with numerical rating)
  - Review count (e.g., "1.5k reviews")
  - Verification badge
  - Specialization badges
  - Quick booking button
  - Availability status

- **Travel Buddy Cards**
  - Profile picture
  - Verification badge
  - Travel interests
  - Destination match
  - Date range match
  - Quick connect button
  - Online status

### Messaging System
- **Tab Navigation**
  - Guides Tab
  - Travel Buddies Tab
  - Support Tab

- **Guides Tab**
  - **Chat List**
    - Active guide conversations
    - Booking status
    - Guide availability
    - Last message preview
    - Unread indicators
    - Quick actions
    - Rating status
    - Payment status

  - **Message Features**
    - Text messages
    - Image sharing
    - Location sharing
    - Voice messages
    - File sharing
    - Quick booking
    - Schedule viewing
    - Payment requests

  - **Guide-specific Features**
    - Booking management
    - Schedule coordination
    - Payment handling
    - Service requests
    - Review submission
    - Guide profile access
    - Service customization
    - Emergency contact

- **Travel Buddies Tab**
  - **Chat List**
    - Active buddy conversations
    - Trip matching status
    - Location sharing
    - Last message preview
    - Unread indicators
    - Quick actions
    - Trust score
    - Verification status

  - **Message Features**
    - Text messages
    - Image sharing
    - Location sharing
    - Voice messages
    - File sharing
    - Trip coordination
    - Meetup planning
    - Expense sharing

  - **Buddy-specific Features**
    - Trip matching
    - Meetup scheduling
    - Expense tracking
    - Location sharing
    - Safety check-ins
    - Profile verification
    - Trust building
    - Group coordination

- **Support Tab**
  - **Dispute Resolution**
    - Issue reporting form
    - Evidence upload
    - Chat history attachment
    - Booking reference
    - Priority selection
    - Category selection
    - Status tracking
    - Resolution timeline

  - **Support Categories**
    - Guide disputes
    - Travel buddy issues
    - Booking problems
    - Payment issues
    - Safety concerns
    - Technical support
    - Account issues
    - General inquiries

  - **Support Features**
    - Live chat support
    - Ticket system
    - FAQ access
    - Resolution status
    - Follow-up options
    - Feedback submission
    - Escalation path
    - Support history

- **Common Features**
  - Translation toggle
  - Message search
  - Media gallery
  - Notification settings
  - Chat backup
  - Block/Report
  - Privacy settings
  - Message retention

### Profile Section
- **User Information**
  - Profile picture
  - Basic details
  - Preferences
  - Settings
  - Privacy controls

- **Identity Verification**
  - **Travel Buddy Verification**
    - [x] ID document upload
    - [x] Selfie verification
    - [x] Address verification
    - [x] Verification status badge
    - [x] Verification history
    - [x] Re-verification options
    - [x] Privacy settings for verification

  - **Guide Verification**
    - Professional ID upload
    - Certification documents
    - Background check status
    - Video interview scheduling
    - Specialization verification
    - Equipment verification
    - Insurance documentation
    - Verification level badge
    - Re-verification options

  - **Verification Status**
    - [x] Overall verification score
    - [x] Verification badges display
    - [x] Verification expiry dates
    - [x] Pending verifications
    - [x] Verification requirements
    - [x] Verification support

- **Safety & Emergency**
  - Emergency button
  - Location sharing
  - Emergency contacts
  - Local emergency numbers
  - Safety alerts
  - Weather warnings
  - Safe zone indicators
  - Safety check feature
  - Quick access to emergency services
  - Location sharing toggle

- **Verification & Trust**
  - ID verification status
  - Trust score visualization
  - Safety guidelines
  - Reporting interface
  - Blocking capabilities
  - Guide verification status
  - Travel buddy verification
  - Document upload
  - Background check status

- **Dispute Resolution**
  - Issue reporting
  - Evidence upload
  - Communication history
  - Resolution tracking
  - Feedback system
  - Guide disputes
  - Travel buddy disputes
  - Booking issues
  - Payment disputes

- **Quick Access**
  - Nearby suggestions
  - Language preferences
  - Notification settings
  - Payment methods
  - Account security
  - Performance settings
  - Accessibility options
  - Voice preferences
  - Help & Support
  - Feedback

## 4. 🛠️ Technical Implementation

### Performance
- Lazy loading for images and content
- Progressive loading for maps
- Cached data for offline access
- Optimized animations
- Efficient state management
- Background data prefetching
- Battery optimization
- Data usage
- Storage management
- Cache control
- Background processes
- Update management

### AI Translation Widget
- **Widget Features**
  - Language pair selection
  - Text input/output
  - Voice input/output
  - Quick translate button
  - History of translations
  - Favorite translations
  - Offline mode support

- **Translation Options**
  - Menu translation
  - Sign translation
  - Document translation
  - Cultural context notes
  - Translation history

- **Widget Settings**
  - Language preferences
  - Voice settings
  - Text size
  - Theme options
  - Widget size
  - Position options

### Development Guidelines
- **Code Structure**
  - Component organization
  - State management
  - API integration
  - Error handling
  - Performance monitoring
  - Testing strategy

- **Asset Management**
  - Image optimization
  - Icon system
  - Font management
  - Animation assets
  - Sound effects
  - Video content

### Analytics & Monitoring
- **User Analytics**
  - Feature usage
  - User paths
  - Conversion rates
  - Retention metrics
  - Error tracking
  - Performance metrics

- **Performance Monitoring**
  - Load times
  - Response times
  - Error rates
  - Resource usage
  - Network performance
  - Battery impact

### Update & Maintenance
- **Version Control**
  - Feature flags
  - A/B testing
  - Rollback procedures
  - Update notifications
  - Beta testing
  - Release management

- **Content Management**
  - Dynamic content
  - Localization
  - Content updates
  - Media management
  - Cache control
  - CDN integration

## 5. 🔄 User Flows

### Onboarding
1. Welcome screen
2. Feature showcase
3. Voice setup
4. Emergency contacts
5. Preferences
6. Quick start guide

### Trip Planning
1. Destination selection
2. Date selection
3. AI/Manual planning
4. Guide integration
5. Buddy matching
6. Finalization

### Guide Booking
1. Guide search
2. Profile review
3. Availability check
4. Booking process
5. Payment
6. Confirmation

### Emergency Response
1. Alert reception
2. Location sharing
3. Contact notification
4. Safe route guidance
5. Emergency services
6. Follow-up

### MVP Core Design System
- **Color Palette (MVP)**
  - Primary: #2196F3
  - Secondary: #FF4081
  - Success: #4CAF50
  - Error: #F44336
  - Background: #FFFFFF
  - Text: #212121

- **Typography (MVP)**
  - Primary Font: Roboto
  - Headings: 24px, 20px, 16px
  - Body: 16px
  - Captions: 14px
  - Buttons: 14px

### MVP Core Screens
1. **Authentication**
   - Sign Up Screen
   - Login Screen
   - Password Reset

2. **Home/Explore**
   - Basic Map View
   - Simple Search
   - Quick Trip Creation

3. **Trip Planning**
   - Basic Itinerary
   - Essential Details
   - Packing List

4. **Guide/Buddy**
   - Basic Search
   - Profile View
   - Simple Booking

5. **Messaging**
   - Basic Chat
   - Message List
   - New Message

### Essential User Flows
1. **New User Onboarding**
   ```
   Start → Sign Up → Profile Setup → Home Screen
   ```

2. **Trip Creation**
   ```
   Home → New Trip → Basic Details → Itinerary → Save
   ```

3. **Guide Search**
   ```
   Home → Guide Search → Filter → Profile → Book
   ```

4. **Basic Messaging**
   ```
   Messages → New Chat → Select User → Send Message
   ```

### AI Integration (MVP)
```typescript
interface AIInteraction {
  // Voice Input
  voiceInput: {
    activation: 'tap' | 'voice',
    timeout: number,
    feedback: {
      listening: boolean,
      processing: boolean,
      success: boolean,
      error: boolean
    }
  },

  // Trip Planning
  tripPlanning: {
    input: {
      destination: string,
      dates: string,
      preferences: string[]
    },
    output: {
      itinerary: Itinerary,
      suggestions: Suggestion[],
      alternatives: Alternative[]
    },
    feedback: {
      accuracy: number,
      relevance: number,
      userRating: number
    }
  },

  // Interaction States
  states: {
    idle: {
      visual: 'microphone icon',
      audio: 'none'
    },
    listening: {
      visual: 'wave animation',
      audio: 'beep'
    },
    processing: {
      visual: 'loading spinner',
      audio: 'none'
    },
    success: {
      visual: 'check mark',
      audio: 'success tone'
    },
    error: {
      visual: 'error icon',
      audio: 'error tone'
    }
  }
}

// AI Interaction Flow
class AIInteractionFlow {
  async handleVoiceInput(): Promise<void> {
    // 1. Activation
    this.setState('listening');
    this.showWaveAnimation();
    this.playActivationSound();

    // 2. Processing
    this.setState('processing');
    this.showLoadingSpinner();
    
    try {
      // 3. AI Processing
      const result = await this.processWithAI();
      
      // 4. Success
      this.setState('success');
      this.showResults(result);
      this.playSuccessSound();
      
      // 5. Feedback Collection
      await this.collectFeedback();
    } catch (error) {
      // 6. Error Handling
      this.setState('error');
      this.showError(error);
      this.playErrorSound();
    }
  }
}
```

### Accessibility (MVP)
- **Screen Reader Support**
  - Alt text for images
  - ARIA labels
  - Semantic HTML
  - Focus management

- **Color Contrast**
  - Minimum 4.5:1 ratio
  - Color-blind friendly
  - High contrast mode

- **Keyboard Navigation**
  - Tab order
  - Focus indicators
  - Keyboard shortcuts
  - Skip links

### Complex Interaction Flows
1. **Conflict Resolution Flow**
   ```
   Detect Conflict → Show Notification → Present Options → User Choice → Resolve → Confirm
   ```

2. **AI Voice Interaction Flow**
   ```
   Activate → Listen → Process → Show Results → Collect Feedback
   ```

3. **Offline Sync Flow**
   ```
   Detect Offline → Queue Changes → Show Status → Auto-sync → Resolve Conflicts
   ```

# Legacy UI Modernization Checklist

Below is a prioritized checklist of all screens/components still using legacy UI patterns (e.g., AppBar, ListTile, AlertDialog, hardcoded colors/styles, direct TextStyle, etc.). Check off each item as it is modernized. 

---

## **Priority 1: Profile Section**
- [x] **Preferences Screen** (`lib/features/profile/presentation/screens/preferences_screen.dart`)
  - Refactored to use custom PreferenceTile and PreferenceDialog widgets, pastel backgrounds, modern switches, and standardized text styles.
- [x] **About Screen** (`lib/features/profile/presentation/screens/about_screen.dart`)
  - Refactored to use PreferenceTile for contact and legal items, pastel backgrounds, rounded corners, and standardized text styles.
- [x] **Contact Support Screen** (`lib/features/profile/presentation/screens/contact_support_screen.dart`)
  - Refactored to use PreferenceTile for support options, pastel backgrounds, rounded corners, and standardized text styles.
- [x] **Help Center Screen** (`lib/features/profile/presentation/screens/help_center_screen.dart`)
  - Refactored FAQ and section headers to use pastel backgrounds, rounded corners, and standardized text styles.
- [x] **Profile Screen** (`lib/features/profile/presentation/screens/profile_screen.dart`)
  - Refactored to use PreferenceTile for all profile section cards, pastel backgrounds, rounded corners, and standardized text styles.

## **Priority 2: Guides Section**
- [x] **Guide List Screen** (`lib/features/guides/presentation/screens/guide_list_screen.dart`)
  - Refactored filter dialog to use PreferenceTile, modernized guide cards with pastel backgrounds, standardized text styles, and modern button style.
- [x] **Guides Screen** (`lib/features/guides/presentation/screens/guides_screen.dart`)
  - Refactored filter dialogs to use PreferenceTile, pastel backgrounds, rounded corners, and standardized text styles.
- [x] **Shared Filter Widgets** (`lib/features/guides/presentation/widgets/shared_filter_widgets.dart`)
  - Refactored SharedFilterDialog to use custom dialog with pastel background, rounded corners, and AppButton actions.

## **Priority 3: Messages Section**
- [x] **Messages Screen** (`lib/features/messages/presentation/screens/messages_screen.dart`)
  - Refactored chat cards to use pastel backgrounds, standardized text styles, and modernized unread badge.

## **Priority 4: Core/Navigation**
- [x] **Bottom Navigation Bar** (`lib/core/widgets/navigation/bottom_navigation_bar.dart`)
  - Refactored to use pastel backgrounds for selected icons, standardized icon colors, and modernized highlight style.

## **General Patterns to Refactor (Global)**
- [ ] Replace all `ListTile` with custom tile widgets using the design system
- [ ] Replace all `AlertDialog`/`SimpleDialog` with custom modal/dialog widgets
- [ ] Replace direct use of `Colors.white`, `Colors.black`, `Colors.grey`, etc. with theme or pastel palette
- [ ] Replace direct `TextStyle` with standardized text styles
- [ ] Standardize legacy paddings (e.g., `EdgeInsets.all(8)`, `EdgeInsets.symmetric(horizontal: 16)`) to match new spacing system

---

*Update this checklist as you modernize each screen/component. For each completed item, check the box and add a brief note on the update.* 
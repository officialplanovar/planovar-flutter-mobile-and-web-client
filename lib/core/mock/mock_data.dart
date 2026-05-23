import '../../shared/models/category_model.dart';
import '../../shared/models/vendor_model.dart';
import '../../shared/models/listing_model.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/models/event_model.dart';
import '../../shared/models/quote_model.dart';
import '../../shared/models/conversation_model.dart';
import '../../shared/models/message_model.dart';
import '../../shared/models/transaction_model.dart';
import '../../shared/models/review_model.dart';
import '../../shared/models/notification_model.dart';
import '../../shared/models/country_model.dart';
import '../../shared/models/city_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/client_profile_model.dart';

class MockData {
  // ─── Current User ────────────────────────────────────────────────────────────
  static final currentUser = UserModel(
    id: 'user-001',
    name: 'Adaeze Okonkwo',
    email: 'adaeze@email.com',
    phone: '+2348012345678',
    firstName: 'Adaeze',
    lastName: 'Okonkwo',
    role: 'client',
    image: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200',
    clientProfile: const ClientProfileModel(
      id: 'cp-001',
      onboardingComplete: true,
      preferredCountry: 'NG',
      preferredCity: 'Lagos',
      categoryPrefs: ['photography', 'catering', 'decor'],
    ),
  );

  // ─── Categories ──────────────────────────────────────────────────────────────
  static final List<CategoryModel> categories = [
    CategoryModel(
      id: 'cat-01', name: 'Photography', slug: 'photography', sortOrder: 1,
      imageUrl: 'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?w=400',
      description: 'Professional photographers for your events',
    ),
    CategoryModel(
      id: 'cat-02', name: 'Videography', slug: 'videography', sortOrder: 2,
      imageUrl: 'https://images.unsplash.com/photo-1574717024453-354056aafa98?w=400',
      description: 'Capture every moment on video',
    ),
    CategoryModel(
      id: 'cat-03', name: 'Catering', slug: 'catering', sortOrder: 3,
      imageUrl: 'https://images.unsplash.com/photo-1555244162-803834f70033?w=400',
      description: 'Delicious food for your events',
    ),
    CategoryModel(
      id: 'cat-04', name: 'Decor', slug: 'decor', sortOrder: 4,
      imageUrl: 'https://images.unsplash.com/photo-1478146059778-26028b07395a?w=400',
      description: 'Beautiful event decorations',
    ),
    CategoryModel(
      id: 'cat-05', name: 'Floral', slug: 'floral', sortOrder: 5,
      imageUrl: 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=400',
      description: 'Stunning floral arrangements',
    ),
    CategoryModel(
      id: 'cat-06', name: 'DJ & Music', slug: 'dj-music', sortOrder: 6,
      imageUrl: 'https://images.unsplash.com/photo-1571266028243-d5f7a2eed3c7?w=400',
      description: 'Keep the party going',
    ),
    CategoryModel(
      id: 'cat-07', name: 'Venues', slug: 'venues', sortOrder: 7,
      imageUrl: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=400',
      description: 'Perfect spaces for your events',
    ),
    CategoryModel(
      id: 'cat-08', name: 'Bands', slug: 'bands', sortOrder: 8,
      imageUrl: 'https://images.unsplash.com/photo-1501386761578-eaa54b3e0e00?w=400',
      description: 'Live music performances',
    ),
    CategoryModel(
      id: 'cat-09', name: 'Drinks', slug: 'drinks', sortOrder: 9,
      imageUrl: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=400',
      description: 'Bar services and beverages',
    ),
    CategoryModel(
      id: 'cat-10', name: 'Emcees', slug: 'emcees', sortOrder: 10,
      imageUrl: 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=400',
      description: 'Professional event hosts',
    ),
    CategoryModel(
      id: 'cat-11', name: 'Beauty', slug: 'beauty', sortOrder: 11,
      imageUrl: 'https://images.unsplash.com/photo-1560066984-138daaa4e4e0?w=400',
      description: 'Hair and makeup artists',
    ),
    CategoryModel(
      id: 'cat-12', name: 'Confectionery', slug: 'confectionery', sortOrder: 12,
      imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
      description: 'Custom cakes and desserts',
    ),
    CategoryModel(
      id: 'cat-13', name: 'Products', slug: 'products', sortOrder: 0,
      imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=400',
      description: 'Browse all event products to buy or rent',
    ),
  ];

  // ─── Vendors ─────────────────────────────────────────────────────────────────
  static final List<VendorModel> vendors = [
    const VendorModel(
      id: 'vendor-01',
      businessName: 'Lumiere Gourmet Catering',
      slug: 'lumiere-gourmet',
      description: 'We are Lagos\'s premier catering service, specialising in contemporary Nigerian cuisine fused with international flavours. With over 10 years of experience serving weddings, corporate events, and private parties, we bring elegance and exceptional taste to every occasion. Our team of trained chefs uses only fresh, locally-sourced ingredients.',
      coverUrl: 'https://images.unsplash.com/photo-1555244162-803834f70033?w=800',
      location: 'Lagos, Nigeria',
      ratingAvg: 4.8,
      reviewCount: 124,
      subscriptionTier: 'featured',
      isVerified: true,
      categories: ['Catering'],
    ),
    const VendorModel(
      id: 'vendor-02',
      businessName: 'Sugared Dreams Cakery',
      slug: 'sugared-dreams',
      description: 'Artisanal cake studio based in Lagos creating edible masterpieces for weddings, birthdays, and all celebrations. Each cake is handcrafted with premium imported ingredients and custom-designed to match your vision. We specialise in tiered wedding cakes, sculpted novelty cakes, and elegant dessert tables.',
      coverUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
      location: 'Lagos, Nigeria',
      ratingAvg: 4.9,
      reviewCount: 89,
      subscriptionTier: 'premium',
      isVerified: true,
      categories: ['Confectionery'],
    ),
    const VendorModel(
      id: 'vendor-03',
      businessName: 'Lumière Photography',
      slug: 'lumiere-photography',
      description: 'Award-winning photography studio based in Abuja capturing life\'s most precious moments. From intimate courthouse weddings to grand celebrations, our documentary-style approach ensures every real emotion is preserved. We offer full-day coverage, engagement shoots, and fine-art prints.',
      coverUrl: 'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?w=800',
      location: 'Abuja, Nigeria',
      ratingAvg: 4.7,
      reviewCount: 67,
      subscriptionTier: 'featured',
      isVerified: true,
      categories: ['Photography'],
    ),
    const VendorModel(
      id: 'vendor-04',
      businessName: 'Flores by Jenny',
      slug: 'flores-by-jenny',
      description: 'Bespoke floral design studio creating stunning arrangements for weddings and special events across Lagos. Jenny and her team source the freshest seasonal blooms from local and international markets to craft arrangements that perfectly complement your event aesthetic — from lush garden romance to sleek modern minimalism.',
      coverUrl: 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=800',
      location: 'Lagos, Nigeria',
      ratingAvg: 4.6,
      reviewCount: 52,
      subscriptionTier: 'basic',
      isVerified: false,
      categories: ['Floral'],
    ),
    const VendorModel(
      id: 'vendor-05',
      businessName: 'Wilson Fisk Entertainment',
      slug: 'wilson-fisk-entertainment',
      description: 'Lagos\'s most in-demand DJ and entertainment company. With a vast music library spanning Afrobeats, Highlife, R&B, Hip-Hop, and international chart-toppers, we guarantee an unforgettable experience. We provide professional sound systems, lighting rigs, and MC services for events of all sizes.',
      coverUrl: 'https://images.unsplash.com/photo-1571266028243-d5f7a2eed3c7?w=800',
      location: 'Lagos, Nigeria',
      ratingAvg: 4.5,
      reviewCount: 93,
      subscriptionTier: 'basic',
      isVerified: true,
      categories: ['DJ & Music'],
    ),
  ];

  // ─── Listings ────────────────────────────────────────────────────────────────
  static final List<ListingModel> listings = [
    // Lumiere Gourmet Catering
    ListingModel(
      id: 'listing-01',
      vendorId: 'vendor-01',
      vendor: vendors[0],
      categoryId: 'cat-03',
      title: 'Wedding Banquet Package',
      description: 'Complete wedding catering solution for up to 500 guests. Includes 5-course sit-down dinner, cocktail hour canapes, wedding cake table setup, full waitstaff, linen and cutlery, and post-event cleanup. Menu is fully customisable.',
      pricingType: 'quote',
      isActive: true,
      isFeatured: true,
      media: [
        'https://images.unsplash.com/photo-1555244162-803834f70033?w=800',
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
      ],
      packages: [
        const ListingPackageModel(
          id: 'pkg-01-a', listingId: 'listing-01',
          name: 'Silver', price: 450000,
          description: 'Perfect for intimate gatherings',
          features: ['Up to 100 guests', '3-course menu', 'Basic waitstaff', 'Standard linen'],
        ),
        const ListingPackageModel(
          id: 'pkg-01-b', listingId: 'listing-01',
          name: 'Gold', price: 900000,
          description: 'Our most popular package',
          features: ['Up to 250 guests', '5-course menu', 'Full waitstaff', 'Premium linen & cutlery', 'Cocktail hour', 'Cake setup'],
        ),
        const ListingPackageModel(
          id: 'pkg-01-c', listingId: 'listing-01',
          name: 'Platinum', price: 1800000,
          description: 'The ultimate luxury experience',
          features: ['Up to 500 guests', '7-course menu', 'Dedicated event manager', 'Premium linen & cutlery', 'Cocktail hour', 'Live cooking stations', 'Dessert bar'],
        ),
      ],
    ),
    ListingModel(
      id: 'listing-02',
      vendorId: 'vendor-01',
      vendor: vendors[0],
      categoryId: 'cat-03',
      title: 'Corporate Lunch & Dinner',
      description: 'Professional catering for corporate events, product launches, and business dinners. We handle everything from menu planning to service, ensuring your guests are impressed.',
      pricingType: 'fixed',
      basePrice: 15000,
      priceUnit: 'per head',
      isActive: true,
      isFeatured: false,
      media: [
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
        'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800',
      ],
      packages: [
        const ListingPackageModel(
          id: 'pkg-02-a', listingId: 'listing-02',
          name: 'Executive Lunch', price: 15000,
          features: ['3-course set menu', 'Still & sparkling water', 'Tea & coffee service', 'Minimum 20 pax'],
        ),
        const ListingPackageModel(
          id: 'pkg-02-b', listingId: 'listing-02',
          name: 'Gala Dinner', price: 35000,
          features: ['5-course dinner', 'Welcome drinks', 'Full bar setup', 'Live cooking station', 'Minimum 50 pax'],
        ),
      ],
    ),
    // Sugared Dreams Cakery
    ListingModel(
      id: 'listing-03',
      vendorId: 'vendor-02',
      vendor: vendors[1],
      categoryId: 'cat-12',
      title: 'Custom Wedding Cake',
      description: 'Bespoke multi-tiered wedding cakes crafted to your exact vision. Choose from vanilla bean, chocolate fudge, red velvet, lemon drizzle, or our signature champagne & strawberry flavour. Fondant or buttercream finish, unlimited design consultation included.',
      pricingType: 'quote',
      isActive: true,
      isFeatured: true,
      media: [
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
        'https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=800',
        'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=800',
      ],
      packages: [
        const ListingPackageModel(
          id: 'pkg-03-a', listingId: 'listing-03',
          name: '2-Tier', price: 120000,
          features: ['Serves 50-80 guests', '2 flavour layers', 'Fondant or buttercream', '1 design consultation', 'Delivery included (Lagos)'],
        ),
        const ListingPackageModel(
          id: 'pkg-03-b', listingId: 'listing-03',
          name: '4-Tier', price: 280000,
          features: ['Serves 150-200 guests', '4 flavour layers', 'Sugar flowers', '3 design consultations', 'Delivery & setup', 'Cake stand rental'],
        ),
        const ListingPackageModel(
          id: 'pkg-03-c', listingId: 'listing-03',
          name: 'Signature Masterpiece', price: 500000,
          features: ['Serves 300+ guests', 'Up to 6 tiers', 'Handcrafted sugar art', 'Unlimited consultations', 'Delivery, setup & display', 'Dessert table styling', 'Cutting service'],
        ),
      ],
    ),
    ListingModel(
      id: 'listing-04',
      vendorId: 'vendor-02',
      vendor: vendors[1],
      categoryId: 'cat-12',
      title: 'Dessert Table Package',
      description: 'Stunning dessert display tables featuring a curated selection of mini cakes, macarons, cake pops, chocolate truffles, and more. Perfect for weddings, baby showers, and birthday parties.',
      pricingType: 'fixed',
      basePrice: 180000,
      priceUnit: 'per package',
      isActive: true,
      isFeatured: false,
      media: [
        'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=800',
        'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800',
      ],
      packages: [
        const ListingPackageModel(
          id: 'pkg-04-a', listingId: 'listing-04',
          name: 'Sweet Dreams', price: 180000,
          features: ['50 mini cupcakes', '30 cake pops', '20 macarons', 'Table styling & display', 'Serves 50 guests'],
        ),
        const ListingPackageModel(
          id: 'pkg-04-b', listingId: 'listing-04',
          name: 'Candy Land', price: 350000,
          features: ['100 mini cupcakes', '60 cake pops', '50 macarons', '24 chocolate truffles', 'Tiered stand', 'Floral accents', 'Serves 100 guests'],
        ),
      ],
    ),
    // Lumière Photography
    ListingModel(
      id: 'listing-05',
      vendorId: 'vendor-03',
      vendor: vendors[2],
      categoryId: 'cat-01',
      title: 'Full-Day Wedding Coverage',
      description: 'Complete wedding photography from bridal prep through to first dance. Two lead photographers, 800+ edited images, online gallery, USB drive, and 10x8 print package.',
      pricingType: 'fixed',
      basePrice: 650000,
      priceUnit: 'per day',
      isActive: true,
      isFeatured: true,
      media: [
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
        'https://images.unsplash.com/photo-1537633552985-df8429e8048b?w=800',
        'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=800',
      ],
      packages: [
        const ListingPackageModel(
          id: 'pkg-05-a', listingId: 'listing-05',
          name: 'Half Day', price: 350000,
          features: ['6 hours coverage', '1 photographer', '400+ edited images', 'Online gallery', '6x4 print set'],
        ),
        const ListingPackageModel(
          id: 'pkg-05-b', listingId: 'listing-05',
          name: 'Full Day', price: 650000,
          features: ['12 hours coverage', '2 photographers', '800+ edited images', 'Online gallery', 'USB drive', '10x8 print package'],
        ),
        const ListingPackageModel(
          id: 'pkg-05-c', listingId: 'listing-05',
          name: 'Luxury Collection', price: 1200000,
          features: ['Full day + pre-wedding shoot', '2 photographers + assistant', '1000+ edited images', 'Fine-art album', 'Canvas wall art', 'Same-day preview slideshow'],
        ),
      ],
    ),
    // Flores by Jenny
    ListingModel(
      id: 'listing-06',
      vendorId: 'vendor-04',
      vendor: vendors[3],
      categoryId: 'cat-05',
      title: 'Wedding Floral Package',
      description: 'Complete wedding florals including bridal bouquet, bridesmaids bouquets, buttonholes, ceremony arch, reception centrepieces, and venue styling. We work with fresh seasonal flowers for the most vibrant displays.',
      pricingType: 'quote',
      isActive: true,
      isFeatured: false,
      media: [
        'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=800',
        'https://images.unsplash.com/photo-1487530811015-780cba07a3b8?w=800',
      ],
      packages: [
        const ListingPackageModel(
          id: 'pkg-06-a', listingId: 'listing-06',
          name: 'Garden Romance', price: 250000,
          features: ['Bridal bouquet', '3 bridesmaids bouquets', '5 buttonholes', '10 centrepieces', 'Ceremony arrangement'],
        ),
        const ListingPackageModel(
          id: 'pkg-06-b', listingId: 'listing-06',
          name: 'Luxe Garden', price: 500000,
          features: ['Statement bridal bouquet', '6 bridesmaids bouquets', '10 buttonholes', 'Floral arch', '20 centrepieces', 'Sweetheart table', 'Pew ends'],
        ),
      ],
    ),
    // ── Lumiere Gourmet Catering – products (fixed price) ──────────────────────
    ListingModel(
      id: 'listing-p01', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Wedding Cake',
      description: 'Award-winning custom cakes for every occasion in Lagos. We bring your vision to life with edible artistry, from classic tiers to sculpted showpieces. A variety of cakes available in so many sizes.',
      pricingType: 'fixed', basePrice: 100000, priceUnit: 'per cake',
      isActive: true, isFeatured: true,
      media: [
        'https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=800',
        'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=800',
        'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=800',
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
      ],
      packages: [],
      reviewCount: 33,
      sizes: ['4x', '3x', '2x', '1x', '0.5x'],
      colors: ['#E53935', '#FB8C00', '#FDD835', '#E0E0E0', '#43A047', '#7E57C2', '#F48FB1'],
    ),
    ListingModel(
      id: 'listing-p02', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Balloon',
      description: 'A variety of cakes available in so many sizes. Stunning balloon arch and décor setups for all event types.',
      pricingType: 'fixed', basePrice: 10000, priceUnit: 'per set',
      isActive: true, isFeatured: false,
      media: [
        'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800',
        'https://images.unsplash.com/photo-1559181567-c3190bbb8de4?w=800',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800',
      ],
      packages: [],
      reviewCount: 27,
      sizes: ['4x', '3x', '2x', '1x', '0.5x'],
      colors: ['#E53935', '#FB8C00', '#FDD835', '#E0E0E0', '#43A047', '#7E57C2', '#F48FB1'],
    ),
    ListingModel(
      id: 'listing-p03', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Gold Cake Stand',
      description: 'Premium gold cake stand rental for weddings and events. Elegant centrepiece for your reception table.',
      pricingType: 'fixed', basePrice: 100000, priceUnit: 'per rental',
      isActive: true, isFeatured: false,
      isRentable: true, perDayRate: 8000, depositAmount: 20000,
      media: [
        'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
        'https://images.unsplash.com/photo-1478146059778-26028b07395a?w=800',
      ],
      packages: [],
      reviewCount: 19,
    ),
    ListingModel(
      id: 'listing-p04', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Custom Birthday Cake',
      description: 'Custom birthday cakes in every flavour and design. Made fresh for your special day.',
      pricingType: 'fixed', basePrice: 10000, priceUnit: 'per cake',
      isActive: true, isFeatured: false,
      media: [
        'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=800',
        'https://images.unsplash.com/photo-1557308536-ee471ef2c390?w=800',
      ],
      packages: [],
      reviewCount: 21,
      sizes: ['4x', '3x', '2x', '1x'],
      colors: ['#E53935', '#FB8C00', '#FDD835', '#43A047', '#7E57C2'],
    ),
    ListingModel(
      id: 'listing-p05', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Gender Reveal Cake',
      description: 'Surprise gender reveal cakes with hidden colour fillings. Order in blue or pink!',
      pricingType: 'fixed', basePrice: 35000, priceUnit: 'per cake',
      isActive: true, isFeatured: false,
      media: [
        'https://images.unsplash.com/photo-1562777717-dc6984f65a63?w=800',
        'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=800',
      ],
      packages: [],
      reviewCount: 14,
      sizes: ['2x', '1x', '0.5x'],
      colors: ['#E53935', '#7E57C2', '#F48FB1'],
    ),
    ListingModel(
      id: 'listing-p06', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Cupcakes',
      description: 'Freshly baked cupcakes in a variety of flavours and decorations for any occasion.',
      pricingType: 'fixed', basePrice: 2500, priceUnit: 'per dozen',
      isActive: true, isFeatured: false,
      media: [
        'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?w=800',
        'https://images.unsplash.com/photo-1587668178277-295251f900ce?w=800',
      ],
      packages: [],
      reviewCount: 42,
      colors: ['#E53935', '#FB8C00', '#F48FB1', '#7E57C2'],
    ),
    // ── Lumiere Gourmet Catering – services (quote) ────────────────────────────
    ListingModel(
      id: 'listing-s01', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Wedding Decoration',
      description: 'Award-winning custom cakes for every occasion in Lagos. We bring your vision to life with edible artistry, from classic tiers to sculpted showpieces.',
      pricingType: 'quote', isActive: true, isFeatured: true,
      media: ['https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
               'https://images.unsplash.com/photo-1478146059778-26028b07395a?w=800'],
      packages: [
        const ListingPackageModel(id: 'pkg-s01-a', listingId: 'listing-s01', name: 'Standard', price: 200000,
          features: ['Venue styling', 'Centrepieces', 'Floral arch']),
        const ListingPackageModel(id: 'pkg-s01-b', listingId: 'listing-s01', name: 'Premium', price: 500000,
          features: ['Full venue transformation', 'Floral arch', 'Sweetheart table', 'Lighting']),
      ],
    ),
    ListingModel(
      id: 'listing-s02', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Dining Arrangement',
      description: 'Elegant dining table arrangements and settings for events of all sizes.',
      pricingType: 'quote', isActive: true, isFeatured: false,
      media: ['https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800'],
      packages: [
        const ListingPackageModel(id: 'pkg-s02-a', listingId: 'listing-s02', name: 'Standard', price: 200000,
          features: ['Table settings', 'Centrepieces', 'Linen']),
        const ListingPackageModel(id: 'pkg-s02-b', listingId: 'listing-s02', name: 'Luxury', price: 500000,
          features: ['Premium settings', 'Floral centrepieces', 'Charger plates', 'Custom menu cards']),
      ],
    ),
    ListingModel(
      id: 'listing-s03', vendorId: 'vendor-01', vendor: vendors[0],
      categoryId: 'cat-03', title: 'Wedding Dressing',
      description: 'Full styling and dressing service for brides and bridal parties.',
      pricingType: 'quote', isActive: true, isFeatured: false,
      media: ['https://images.unsplash.com/photo-1549417229-aa67d3263c09?w=800'],
      packages: [
        const ListingPackageModel(id: 'pkg-s03-a', listingId: 'listing-s03', name: 'Bride Only', price: 200000,
          features: ['Bridal styling', 'Makeup', 'Hair']),
        const ListingPackageModel(id: 'pkg-s03-b', listingId: 'listing-s03', name: 'Full Party', price: 500000,
          features: ['Bride + 4 bridesmaids', 'Full makeup & hair', 'Touch-up kit']),
      ],
    ),
    // Wilson Fisk Entertainment
    ListingModel(
      id: 'listing-07',
      vendorId: 'vendor-05',
      vendor: vendors[4],
      categoryId: 'cat-06',
      title: 'Wedding DJ & MC Package',
      description: 'Complete wedding entertainment from cocktail hour through to last dance. Professional DJ with full sound system, wireless microphones, intelligent lighting rig, and MC services to keep your guests entertained all night.',
      pricingType: 'fixed',
      basePrice: 350000,
      priceUnit: 'per event',
      isActive: true,
      isFeatured: false,
      media: [
        'https://images.unsplash.com/photo-1571266028243-d5f7a2eed3c7?w=800',
        'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800',
      ],
      packages: [
        const ListingPackageModel(
          id: 'pkg-07-a', listingId: 'listing-07',
          name: 'Essential', price: 200000,
          features: ['4 hours', 'DJ only', 'Basic sound system', 'Standard lighting', 'Music request handling'],
        ),
        const ListingPackageModel(
          id: 'pkg-07-b', listingId: 'listing-07',
          name: 'Premium', price: 350000,
          features: ['8 hours', 'DJ + MC', 'Professional sound system', 'LED lighting rig', 'Wireless mic for speeches', 'Online playlist planner'],
        ),
        const ListingPackageModel(
          id: 'pkg-07-c', listingId: 'listing-07',
          name: 'Ultimate Party', price: 600000,
          features: ['12 hours', 'DJ + MC + Assistant', 'Premium line array speakers', 'Moving head lights + LED wall', '2 wireless mics', 'Photo booth integration', 'Live Instagram feed display'],
        ),
      ],
    ),
  ];

  // ─── User Events ─────────────────────────────────────────────────────────────
  static final List<EventModel> events = [
    EventModel(
      id: 'event-01', clientId: 'user-001', name: 'Wedding Party',
      date: DateTime(2026, 3, 14), location: 'Eko Hotel & Suites, Lagos',
      guestCount: 200, durationHours: 3,
      budgetMin: 200000, budgetMax: 500000,
      coverUrl: 'https://images.unsplash.com/photo-1535141192574-5d4897c12636?w=400',
    ),
    EventModel(
      id: 'event-02', clientId: 'user-001', name: 'Photoshoot',
      date: DateTime(2026, 4, 5), location: 'Victoria Island, Lagos',
      guestCount: 10, durationHours: 4,
      budgetMin: 230000, budgetMax: 340000,
      coverUrl: 'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?w=400',
    ),
    EventModel(
      id: 'event-03', clientId: 'user-001', name: 'Birthday Party',
      date: DateTime(2026, 6, 20), location: 'Lekki Phase 1, Lagos',
      guestCount: 80, durationHours: 5,
      budgetMin: 200000, budgetMax: 500000,
      coverUrl: 'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=400',
    ),
  ];

  // ─── Bookings ────────────────────────────────────────────────────────────────
  static final List<BookingModel> bookings = [
    BookingModel(
      id: 'booking-01',
      clientId: 'user-001',
      vendorId: 'vendor-01',
      vendor: vendors[0],
      listingId: 'listing-01',
      listing: listings[0],
      status: 'pending',
      eventDate: DateTime(2026, 8, 15),
      eventLocation: 'Eko Hotel & Suites, Lagos',
      requirements: 'We need catering for approximately 300 guests. We\'d like a mixture of Nigerian and continental food. The event is a traditional wedding ceremony followed by a white wedding reception. Please quote for both events.',
      quoteAmount: 850000,
    ),
    BookingModel(
      id: 'booking-02',
      clientId: 'user-001',
      vendorId: 'vendor-03',
      vendor: vendors[2],
      listingId: 'listing-05',
      listing: listings[4],
      status: 'confirmed',
      eventDate: DateTime(2026, 8, 15),
      eventLocation: 'Abuja, Nigeria',
      requirements: 'Full day wedding photography. We want natural, documentary-style shots. Bridal prep starts at 8am.',
      quoteAmount: 650000,
      finalAmount: 650000,
    ),
    BookingModel(
      id: 'booking-03',
      clientId: 'user-001',
      vendorId: 'vendor-02',
      vendor: vendors[1],
      listingId: 'listing-03',
      listing: listings[2],
      status: 'completed',
      eventDate: DateTime(2026, 3, 22),
      eventLocation: 'Lagos, Nigeria',
      requirements: '4-tier wedding cake, champagne and strawberry flavour. Colour scheme: ivory and dusty rose.',
      quoteAmount: 280000,
      finalAmount: 280000,
    ),
  ];

  // ─── Quotes ──────────────────────────────────────────────────────────────────
  static final List<QuoteModel> quotes = [
    QuoteModel(
      id: 'quote-01',
      bookingId: 'booking-01',
      vendorId: 'vendor-01',
      vendor: vendors[0],
      amount: 850000,
      description: 'Quote for wedding catering — 300 guests. Includes Nigerian and continental buffet, full waitstaff, linen, and cleanup. Price is per person at ₦2,833.',
      lineItems: const [
        QuoteLineItem(label: 'Nigerian Buffet (300 pax)', amount: 450000),
        QuoteLineItem(label: 'Continental Station (300 pax)', amount: 200000),
        QuoteLineItem(label: 'Waitstaff (15 staff × 8hrs)', amount: 120000),
        QuoteLineItem(label: 'Linen & Cutlery', amount: 50000),
        QuoteLineItem(label: 'Setup & Cleanup', amount: 30000),
      ],
      validUntil: DateTime(2026, 6, 30),
      status: 'pending',
    ),
    QuoteModel(
      id: 'quote-02',
      bookingId: 'booking-02',
      vendorId: 'vendor-03',
      vendor: vendors[2],
      amount: 650000,
      description: 'Full-day wedding photography package — 12 hours coverage with 2 photographers.',
      lineItems: const [
        QuoteLineItem(label: 'Full Day Coverage (2 photographers)', amount: 500000),
        QuoteLineItem(label: 'Edited digital gallery (800+ images)', amount: 80000),
        QuoteLineItem(label: 'USB Drive + 10x8 print package', amount: 70000),
      ],
      validUntil: DateTime(2026, 7, 15),
      status: 'accepted',
    ),
    QuoteModel(
      id: 'quote-03',
      bookingId: 'booking-04',
      vendorId: 'vendor-07',
      vendor: _davisonNail,
      amount: 85000,
      description: 'Nail art package for bridal party — 6 persons.',
      lineItems: const [
        QuoteLineItem(label: 'Bridal nail art (1 person)', amount: 25000),
        QuoteLineItem(label: 'Bridesmaid nail art (5 persons)', amount: 50000),
        QuoteLineItem(label: 'Nail supplies & topcoat', amount: 10000),
      ],
      validUntil: DateTime(2026, 7, 1),
      status: 'declined',
    ),
  ];

  // ─── Extra vendors for conversations ─────────────────────────────────────────
  static const _winesWinery = VendorModel(
    id: 'vendor-06', businessName: 'Wines Winery', slug: 'wines-winery',
    description: 'Premium wine and cocktail bar services for events.',
    coverUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=400',
    location: 'Lagos, Nigeria', ratingAvg: 4.4, reviewCount: 38,
    subscriptionTier: 'basic', isVerified: true, categories: ['Drinks'],
  );
  static const _davisonNail = VendorModel(
    id: 'vendor-07', businessName: 'Davison Nail tech', slug: 'davison-nail',
    description: 'Professional nail art and beauty services for events.',
    coverUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=400',
    location: 'Lagos, Nigeria', ratingAvg: 4.3, reviewCount: 21,
    subscriptionTier: 'basic', isVerified: false, categories: ['Beauty'],
  );

  // ─── Conversations ────────────────────────────────────────────────────────────
  static final List<ConversationModel> conversations = [
    ConversationModel(
      id: 'conv-group-01',
      vendorId: '',
      vendor: null,
      groupName: 'Our Wedding – Vendor Group',
      eventId: 'event-01',
      isGroup: true,
      groupVendors: [vendors[0], vendors[2], vendors[1]],
      lastMessage: 'Cake delivery confirmed for 10am 🎂',
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 8)),
      unreadCount: 3,
      status: 'confirmed',
    ),
    ConversationModel(
      id: 'conv-01', vendorId: 'vendor-01', vendor: vendors[0],
      lastMessage: 'Quote sent',
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 23)),
      unreadCount: 1, pendingQuoteAmount: 100000, status: 'active',
      isGroup: false, groupVendors: const [],
    ),
    ConversationModel(
      id: 'conv-02', vendorId: 'vendor-03', vendor: vendors[2],
      lastMessage: 'Booking confirmed',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 3, hours: 23)),
      unreadCount: 0, status: 'confirmed',
      isGroup: false, groupVendors: const [],
    ),
    ConversationModel(
      id: 'conv-03', vendorId: 'vendor-06', vendor: _winesWinery,
      lastMessage: 'Payment confirmed ✓',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      unreadCount: 0, status: 'confirmed',
      isGroup: false, groupVendors: const [],
    ),
    ConversationModel(
      id: 'conv-04', vendorId: 'vendor-07', vendor: _davisonNail,
      lastMessage: 'No problem, feel free to reach out again!',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 4)),
      unreadCount: 0, status: 'active',
      isGroup: false, groupVendors: const [],
    ),
    ConversationModel(
      id: 'conv-05', vendorId: 'vendor-04', vendor: vendors[3],
      lastMessage: 'Dispute submitted',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 8)),
      unreadCount: 0, status: 'disputed',
      isGroup: false, groupVendors: const [],
    ),
    ConversationModel(
      id: 'conv-06', vendorId: 'vendor-05', vendor: vendors[4],
      lastMessage: 'Review submitted ⭐',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0, status: 'completed',
      isGroup: false, groupVendors: const [],
    ),
    ConversationModel(
      id: 'conv-07', vendorId: 'vendor-02', vendor: vendors[1],
      lastMessage: 'Booking cancelled',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      unreadCount: 0, status: 'cancelled',
      isGroup: false, groupVendors: const [],
    ),
  ];

  // ─── Messages ────────────────────────────────────────────────────────────────
  static List<MessageModel> messagesForConversation(String conversationId) {
    if (conversationId == 'conv-group-01') {
      return [
        MessageModel(id: 'msg-g01', conversationId: 'conv-group-01', senderId: 'user-001',
          content: 'Hey everyone! Just wanted to check in on preparations for August 15th. How is everything going on your end?',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 40))),
        MessageModel(id: 'msg-g02', conversationId: 'conv-group-01', senderId: 'vendor-03',
          content: 'Hi Adaeze! We\'re all set for the photography. Arriving at 7:30am for setup and prep shots. Will need access to the bridal suite from 8am.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 30))),
        MessageModel(id: 'msg-g03', conversationId: 'conv-group-01', senderId: 'vendor-01',
          content: 'Catering team will be at the venue by 11am. We\'ll need the kitchen access from 11am–1pm for prep. Menu is confirmed: Nigerian & continental buffet for 300 guests.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 20))),
        MessageModel(id: 'msg-g04', conversationId: 'conv-group-01', senderId: 'user-001',
          content: 'Perfect! The venue manager\'s contact is Mr. Tunde — 0802-XXX-XXXX. Please coordinate with him directly on arrival for key access.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 10))),
        MessageModel(id: 'msg-g05', conversationId: 'conv-group-01', senderId: 'vendor-02',
          content: 'Got it! Cake delivery is confirmed for 10am. It\'s a 5-tier champagne and strawberry design. Will need a table at least 1.2m × 0.8m reserved near the entrance.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 50))),
        MessageModel(id: 'msg-g06', conversationId: 'conv-group-01', senderId: 'vendor-03',
          content: 'Quick reminder — family portraits are scheduled for 2:30pm before the reception. Please make sure immediate family members are available at that time.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30))),
        MessageModel(id: 'msg-g07', conversationId: 'conv-group-01', senderId: 'user-001',
          content: 'Great, I\'ll let the family know. Also — the ceremony starts at 12pm sharp. Please make sure everything is in place by 11:45am.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 1))),
        MessageModel(id: 'msg-g08', conversationId: 'conv-group-01', senderId: 'vendor-01',
          content: 'Understood. We\'ll have the buffet fully set up and ready by 11:30am.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(minutes: 45))),
        MessageModel(id: 'msg-g09', conversationId: 'conv-group-01', senderId: 'vendor-02',
          content: 'Cake delivery confirmed for 10am 🎂',
          type: 'text', isRead: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 8))),
      ];
    }
    if (conversationId == 'conv-01') {
      return [
        MessageModel(
          id: 'msg-01', conversationId: 'conv-01', senderId: 'user-001',
          content: 'Hi! I\'d like to enquire about catering for my wedding in August. We\'re expecting around 300 guests.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        ),
        MessageModel(
          id: 'msg-02', conversationId: 'conv-01', senderId: 'vendor-01',
          content: 'Hello Adaeze! Congratulations on your upcoming wedding! We\'d love to be part of your special day. Could you share more details about the menu preference and venue?',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
        ),
        MessageModel(
          id: 'msg-03', conversationId: 'conv-01', senderId: 'user-001',
          content: 'We want a mix of Nigerian and continental food. The venue is Eko Hotel & Suites.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        MessageModel(
          id: 'msg-04', conversationId: 'conv-01', senderId: 'vendor-01',
          content: 'Excellent choice! Eko Hotel is a wonderful venue. I\'ve prepared an initial quote for your review.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 22)),
        ),
        MessageModel(
          id: 'msg-05', conversationId: 'conv-01', senderId: 'vendor-01',
          content: null,
          type: 'quote', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 22)),
          quote: quotes[0],
        ),
        MessageModel(
          id: 'msg-06', conversationId: 'conv-01', senderId: 'user-001',
          content: 'Thank you for the quote! Could you reduce the waitstaff cost? We already have venue staff included.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        MessageModel(
          id: 'msg-07', conversationId: 'conv-01', senderId: 'user-001',
          content: 'Ahh Oga this is too much now please can u reduce the man power I don\'t mind just one person',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(minutes: 50)),
        ),
        MessageModel(
          id: 'msg-08', conversationId: 'conv-01', senderId: 'vendor-01',
          content: 'Okay that would be ₦25,000 your total will be ₦75,000 that is the last price',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
        ),
        MessageModel(
          id: 'msg-09', conversationId: 'conv-01', senderId: 'user-001',
          content: 'Hmm okay o no wahala lets do it, send invoice',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
        ),
        MessageModel(
          id: 'msg-10', conversationId: 'conv-01', senderId: 'vendor-01',
          content: 'Invoice for wedding decoration',
          type: 'invoice', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          quote: QuoteModel(
            id: 'invoice-01', bookingId: 'booking-01', vendorId: 'vendor-01',
            vendor: vendors[0], amount: 100000,
            description: 'Invoice for wedding decoration',
            lineItems: const [
              QuoteLineItem(label: 'Man power', amount: 75000),
              QuoteLineItem(label: 'Setup & delivery (Lekki)', amount: 15000),
              QuoteLineItem(label: 'Platform Fee', amount: 10000),
            ],
            validUntil: DateTime.now().add(const Duration(hours: 12)),
            status: 'pending',
          ),
        ),
      ];
    }
    if (conversationId == 'conv-02') {
      return [
        MessageModel(
          id: 'msg-201', conversationId: 'conv-02', senderId: 'user-001',
          content: 'Hello! We\'re looking for a wedding photographer for August 15th in Abuja.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        MessageModel(
          id: 'msg-202', conversationId: 'conv-02', senderId: 'vendor-03',
          content: 'Great news — we have availability on that date! Here\'s our quote for full-day coverage.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 20)),
        ),
        MessageModel(
          id: 'msg-203', conversationId: 'conv-02', senderId: 'vendor-03',
          content: null,
          type: 'quote', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 20)),
          quote: quotes[1],
        ),
        MessageModel(
          id: 'msg-204', conversationId: 'conv-02', senderId: 'user-001',
          content: 'This looks perfect! I\'ll accept this quote.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        MessageModel(
          id: 'msg-205', conversationId: 'conv-02', senderId: 'system',
          content: 'Invoice accepted',
          type: 'invoice_accepted', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 23)),
        ),
        MessageModel(
          id: 'msg-205b', conversationId: 'conv-02', senderId: 'system',
          content: null,
          type: 'booking_confirmed', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 23)),
          quote: quotes[1],
        ),
        MessageModel(
          id: 'msg-206', conversationId: 'conv-02', senderId: 'vendor-03',
          content: 'Looking forward to shooting your big day!',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];
    }
    if (conversationId == 'conv-03') {
      return [
        MessageModel(id: 'msg-301', conversationId: 'conv-03', senderId: 'user-001',
          content: 'Hi! I need a full cocktail bar setup for 200 guests. What are your packages?',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5))),
        MessageModel(id: 'msg-302', conversationId: 'conv-03', senderId: 'vendor-06',
          content: 'Hello! We\'d love to help. Here\'s our quote for premium open bar service.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 20))),
        MessageModel(id: 'msg-303', conversationId: 'conv-03', senderId: 'vendor-06',
          content: null, type: 'quote', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 20)),
          quote: QuoteModel(
            id: 'quote-conv03', bookingId: 'booking-conv03', vendorId: 'vendor-06',
            vendor: _winesWinery, amount: 180000,
            description: 'Full open bar — 200 guests',
            lineItems: const [
              QuoteLineItem(label: 'Premium spirits & mixers', amount: 100000),
              QuoteLineItem(label: '2 Bartenders (8 hrs each)', amount: 50000),
              QuoteLineItem(label: 'Bar equipment & glassware', amount: 30000),
            ],
            validUntil: DateTime(2026, 6, 28), status: 'accepted',
          )),
        MessageModel(id: 'msg-304', conversationId: 'conv-03', senderId: 'user-001',
          content: 'Looks good! Please send the invoice.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4))),
        MessageModel(id: 'msg-305', conversationId: 'conv-03', senderId: 'vendor-06',
          content: 'Invoice for cocktail bar service',
          type: 'invoice', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 22)),
          quote: QuoteModel(
            id: 'invoice-conv03', bookingId: 'booking-conv03', vendorId: 'vendor-06',
            vendor: _winesWinery, amount: 180000,
            description: 'Invoice for cocktail bar service',
            lineItems: const [
              QuoteLineItem(label: 'Premium spirits & mixers', amount: 100000),
              QuoteLineItem(label: '2 Bartenders (8 hrs each)', amount: 50000),
              QuoteLineItem(label: 'Bar equipment & glassware', amount: 20000),
              QuoteLineItem(label: 'Platform Fee', amount: 10000),
            ],
            validUntil: DateTime(2026, 6, 28), status: 'pending',
          )),
        MessageModel(id: 'msg-306', conversationId: 'conv-03', senderId: 'system',
          content: 'Invoice accepted', type: 'invoice_accepted', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 20))),
        MessageModel(id: 'msg-307', conversationId: 'conv-03', senderId: 'system',
          content: null, type: 'booking_confirmed', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 20)),
          quote: QuoteModel(
            id: 'invoice-conv03', bookingId: 'booking-conv03', vendorId: 'vendor-06',
            vendor: _winesWinery, amount: 180000, description: 'Cocktail bar service',
            lineItems: const [], validUntil: DateTime(2026, 6, 28), status: 'accepted',
          )),
        MessageModel(id: 'msg-308', conversationId: 'conv-03', senderId: 'system',
          content: 'Payment of ₦180,000 confirmed', type: 'payment_confirmed', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4))),
      ];
    }
    if (conversationId == 'conv-04') {
      return [
        MessageModel(id: 'msg-401', conversationId: 'conv-04', senderId: 'user-001',
          content: 'Hi! I\'m interested in bridal nail services for my wedding party of 6.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 6))),
        MessageModel(id: 'msg-402', conversationId: 'conv-04', senderId: 'vendor-07',
          content: 'Hello! We\'d love to pamper your bridal party. Here\'s our quote.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 4))),
        MessageModel(id: 'msg-403', conversationId: 'conv-04', senderId: 'vendor-07',
          content: null, type: 'quote', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
          quote: quotes[2]),
        MessageModel(id: 'msg-404', conversationId: 'conv-04', senderId: 'vendor-07',
          content: 'Invoice for bridal nail service',
          type: 'invoice', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          quote: QuoteModel(
            id: 'invoice-conv04', bookingId: 'booking-conv04', vendorId: 'vendor-07',
            vendor: _davisonNail, amount: 90000,
            description: 'Invoice for bridal nail service',
            lineItems: const [
              QuoteLineItem(label: 'Bridal nail art (1 person)', amount: 25000),
              QuoteLineItem(label: 'Bridesmaid nail art (5 persons)', amount: 50000),
              QuoteLineItem(label: 'Nail supplies & topcoat', amount: 10000),
              QuoteLineItem(label: 'Platform Fee', amount: 5000),
            ],
            validUntil: DateTime.now().add(const Duration(hours: 8)), status: 'pending',
          )),
        MessageModel(id: 'msg-405', conversationId: 'conv-04', senderId: 'system',
          content: 'Invoice declined', type: 'invoice_declined', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 6))),
        MessageModel(id: 'msg-406', conversationId: 'conv-04', senderId: 'user-001',
          content: 'The price is a bit higher than our budget. Thanks anyway!',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 5))),
        MessageModel(id: 'msg-407', conversationId: 'conv-04', senderId: 'vendor-07',
          content: 'No problem, feel free to reach out again!',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 4))),
      ];
    }
    if (conversationId == 'conv-05') {
      return [
        MessageModel(id: 'msg-501', conversationId: 'conv-05', senderId: 'user-001',
          content: 'Hi, I\'d like to discuss florals for our event. We want lilac and white arrangements.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4))),
        MessageModel(id: 'msg-502', conversationId: 'conv-05', senderId: 'vendor-04',
          content: 'Yes, we can provide lilac and white arrangements. Let me send over our invoice.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 22))),
        MessageModel(id: 'msg-503', conversationId: 'conv-05', senderId: 'vendor-04',
          content: 'Invoice for floral arrangements',
          type: 'invoice', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 20)),
          quote: QuoteModel(
            id: 'invoice-conv05', bookingId: 'booking-conv05', vendorId: 'vendor-04',
            vendor: vendors[3], amount: 220000,
            description: 'Floral arrangements — lilac & white theme',
            lineItems: const [
              QuoteLineItem(label: 'Bridal bouquet (premium)', amount: 45000),
              QuoteLineItem(label: 'Table centrepieces ×10', amount: 120000),
              QuoteLineItem(label: 'Arch & entrance decor', amount: 45000),
              QuoteLineItem(label: 'Platform Fee', amount: 10000),
            ],
            validUntil: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
            status: 'accepted',
          )),
        MessageModel(id: 'msg-504', conversationId: 'conv-05', senderId: 'system',
          content: 'Invoice accepted', type: 'invoice_accepted', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 18))),
        MessageModel(id: 'msg-505', conversationId: 'conv-05', senderId: 'system',
          content: 'Payment of ₦220,000 confirmed', type: 'payment_confirmed', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3))),
        MessageModel(id: 'msg-506', conversationId: 'conv-05', senderId: 'system',
          content: 'Wrong flowers delivered — received red roses instead of lilac arrangements.',
          type: 'dispute_raised', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 8))),
      ];
    }
    if (conversationId == 'conv-06') {
      return [
        MessageModel(id: 'msg-601', conversationId: 'conv-06', senderId: 'user-001',
          content: 'Hello! I\'d like to book your DJ services for my event on June 14th.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 10))),
        MessageModel(id: 'msg-602', conversationId: 'conv-06', senderId: 'vendor-05',
          content: 'That sounds perfect! When would you like to schedule a call to go over the details?',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 9, hours: 20))),
        MessageModel(id: 'msg-603', conversationId: 'conv-06', senderId: 'vendor-05',
          content: 'Invoice for DJ services',
          type: 'invoice', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
          quote: QuoteModel(
            id: 'invoice-conv06', bookingId: 'booking-conv06', vendorId: 'vendor-05',
            vendor: vendors[4], amount: 150000,
            description: 'DJ services — full event coverage',
            lineItems: const [
              QuoteLineItem(label: 'DJ performance (6 hrs)', amount: 100000),
              QuoteLineItem(label: 'Sound & lighting equipment', amount: 35000),
              QuoteLineItem(label: 'Platform Fee', amount: 15000),
            ],
            validUntil: DateTime.now().subtract(const Duration(days: 7, hours: 12)),
            status: 'accepted',
          )),
        MessageModel(id: 'msg-604', conversationId: 'conv-06', senderId: 'system',
          content: 'Invoice accepted', type: 'invoice_accepted', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 7, hours: 23))),
        MessageModel(id: 'msg-605', conversationId: 'conv-06', senderId: 'system',
          content: 'Payment of ₦150,000 confirmed', type: 'payment_confirmed', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 7))),
        MessageModel(id: 'msg-606', conversationId: 'conv-06', senderId: 'system',
          content: 'Your event was yesterday. How did it go? Share your experience!',
          type: 'review_requested', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 3))),
        MessageModel(id: 'msg-607', conversationId: 'conv-06', senderId: 'system',
          content: 'Review submitted', type: 'review_submitted', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 1))),
      ];
    }
    if (conversationId == 'conv-07') {
      return [
        MessageModel(id: 'msg-701', conversationId: 'conv-07', senderId: 'user-001',
          content: 'Hi! I\'d like to discuss a custom cake design for our event.',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5))),
        MessageModel(id: 'msg-702', conversationId: 'conv-07', senderId: 'vendor-02',
          content: 'Of course! That sounds wonderful. When would you like to discuss the design?',
          type: 'text', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 20))),
        MessageModel(id: 'msg-703', conversationId: 'conv-07', senderId: 'vendor-02',
          content: 'Invoice for wedding cake',
          type: 'invoice', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          quote: QuoteModel(
            id: 'invoice-conv07', bookingId: 'booking-conv07', vendorId: 'vendor-02',
            vendor: vendors[1], amount: 120000,
            description: '5-tier wedding cake',
            lineItems: const [
              QuoteLineItem(label: '5-tier fondant cake (custom design)', amount: 95000),
              QuoteLineItem(label: 'Delivery & setup', amount: 15000),
              QuoteLineItem(label: 'Platform Fee', amount: 10000),
            ],
            validUntil: DateTime.now().subtract(const Duration(days: 2, hours: 18)),
            status: 'accepted',
          )),
        MessageModel(id: 'msg-704', conversationId: 'conv-07', senderId: 'system',
          content: 'Invoice accepted', type: 'invoice_accepted', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 20))),
        MessageModel(id: 'msg-705', conversationId: 'conv-07', senderId: 'system',
          content: 'This booking has been cancelled.', type: 'booking_cancelled', isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2))),
      ];
    }
    return [];
  }

  // ─── Transactions ────────────────────────────────────────────────────────────
  static final List<TransactionModel> transactions = [
    TransactionModel(
      id: 'txn-01', bookingId: 'booking-02',
      type: 'payment', amount: 325000,
      currency: 'NGN', status: 'completed',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    TransactionModel(
      id: 'txn-02', bookingId: 'booking-03',
      type: 'payment', amount: 280000,
      currency: 'NGN', status: 'completed',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  // ─── Reviews ─────────────────────────────────────────────────────────────────
  static final List<ReviewModel> reviews = [
    ReviewModel(
      id: 'rev-01',
      bookingId: 'booking-03',
      reviewerId: 'user-001',
      vendorId: 'vendor-02',
      vendor: vendors[1],
      rating: 5.0,
      title: 'Absolutely stunning cake!',
      body: 'Sugared Dreams exceeded all my expectations. The cake was not only beautiful but tasted incredible. Jenny was so professional and patient throughout the design process. Our guests could not stop complimenting it. Highly recommend!',
      createdAt: DateTime.now().subtract(const Duration(days: 55)),
    ),
  ];

  // ─── Notifications ────────────────────────────────────────────────────────────
  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif-01', type: 'quote',
      title: 'New Quote Received',
      body: 'Lumiere Gourmet Catering has sent you a revised quote of ₦790,000 for your wedding catering.',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 23)),
    ),
    NotificationModel(
      id: 'notif-02', type: 'booking',
      title: 'Booking Confirmed',
      body: 'Your photography booking with Lumière Photography for 15 August 2026 has been confirmed.',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif-03', type: 'payment',
      title: 'Payment Successful',
      body: 'Your payment of ₦325,000 to Lumière Photography has been processed successfully.',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    NotificationModel(
      id: 'notif-04', type: 'booking',
      title: 'Event Reminder',
      body: 'Your event with Sugared Dreams Cakery is coming up in 3 days. Ensure all final details are confirmed.',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    NotificationModel(
      id: 'notif-05', type: 'general',
      title: 'Welcome to Planovar!',
      body: 'Start planning your perfect event by exploring vendors in your area.',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
  ];

  // ─── Countries ────────────────────────────────────────────────────────────────
  static final List<CountryModel> countries = [
    const CountryModel(id: 'NG', name: 'Nigeria', code: 'NG', dialCode: '+234', flagEmoji: '🇳🇬'),
    const CountryModel(id: 'GH', name: 'Ghana', code: 'GH', dialCode: '+233', flagEmoji: '🇬🇭'),
    const CountryModel(id: 'KE', name: 'Kenya', code: 'KE', dialCode: '+254', flagEmoji: '🇰🇪'),
    const CountryModel(id: 'ZA', name: 'South Africa', code: 'ZA', dialCode: '+27', flagEmoji: '🇿🇦'),
    const CountryModel(id: 'GB', name: 'United Kingdom', code: 'GB', dialCode: '+44', flagEmoji: '🇬🇧'),
    const CountryModel(id: 'US', name: 'United States', code: 'US', dialCode: '+1', flagEmoji: '🇺🇸'),
  ];

  // ─── Cities ──────────────────────────────────────────────────────────────────
  static final Map<String, List<CityModel>> citiesByCountry = {
    'NG': [
      const CityModel(id: 'city-lag', name: 'Lagos', state: 'Lagos State', latitude: 6.5244, longitude: 3.3792),
      const CityModel(id: 'city-abj', name: 'Abuja', state: 'FCT', latitude: 9.0765, longitude: 7.3986),
      const CityModel(id: 'city-ph', name: 'Port Harcourt', state: 'Rivers State', latitude: 4.8156, longitude: 7.0498),
      const CityModel(id: 'city-kano', name: 'Kano', state: 'Kano State', latitude: 12.0022, longitude: 8.5920),
      const CityModel(id: 'city-ib', name: 'Ibadan', state: 'Oyo State', latitude: 7.3775, longitude: 3.9470),
      const CityModel(id: 'city-en', name: 'Enugu', state: 'Enugu State', latitude: 6.4584, longitude: 7.5464),
    ],
    'GH': [
      const CityModel(id: 'city-acc', name: 'Accra', state: 'Greater Accra', latitude: 5.6037, longitude: -0.1870),
      const CityModel(id: 'city-kum', name: 'Kumasi', state: 'Ashanti', latitude: 6.6885, longitude: -1.6244),
    ],
    'KE': [
      const CityModel(id: 'city-nai', name: 'Nairobi', state: 'Nairobi County', latitude: -1.2921, longitude: 36.8219),
      const CityModel(id: 'city-mom', name: 'Mombasa', state: 'Mombasa County', latitude: -4.0435, longitude: 39.6682),
    ],
  };

  // ─── FAQ ─────────────────────────────────────────────────────────────────────
  static final List<Map<String, String>> faqs = [
    {
      'question': 'How do I book a vendor?',
      'answer': 'Browse vendors, tap on one you like, view their listings, and tap "Request a Quote" or "Book Now". Fill in your event details and submit. The vendor will respond within 24 hours.',
    },
    {
      'question': 'How does the payment process work?',
      'answer': 'Once a vendor accepts your booking and you accept their quote, you\'ll pay a 50% deposit to confirm the booking. The remaining balance is due 7 days before your event.',
    },
    {
      'question': 'Can I cancel a booking?',
      'answer': 'Yes, you can cancel a booking before it is confirmed at no charge. After confirmation, our cancellation policy applies — please review the vendor\'s cancellation terms in their profile.',
    },
    {
      'question': 'What if I\'m not satisfied with a vendor?',
      'answer': 'Contact our support team within 48 hours of your event. We\'ll mediate with the vendor and work towards a resolution, including partial refunds where appropriate.',
    },
    {
      'question': 'Are vendors verified?',
      'answer': 'Vendors with a verified badge have had their business credentials and portfolio reviewed by our team. We also use client reviews to maintain quality standards.',
    },
    {
      'question': 'How do I leave a review?',
      'answer': 'After your event is marked as completed, you\'ll receive a prompt to leave a review. You can also go to Bookings → Past → the completed booking → Leave Review.',
    },
  ];
}

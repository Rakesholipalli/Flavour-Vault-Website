-- ============================================
-- Flavour Vault Recipe Database
-- Database Schema for Recipe Management System
-- ============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS flavour_vault;
USE flavour_vault;

-- ============================================
-- Table: categories
-- Stores recipe categories
-- ============================================
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================
-- Table: recipes
-- Stores main recipe information
-- ============================================
CREATE TABLE IF NOT EXISTS recipes (
    id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    description TEXT NOT NULL,
    image VARCHAR(255),
    prep_time INT COMMENT 'Preparation time in minutes',
    cook_time INT COMMENT 'Cooking time in minutes',
    servings INT DEFAULT 4,
    difficulty ENUM('Easy', 'Medium', 'Hard') DEFAULT 'Medium',
    rating DECIMAL(3,2) DEFAULT 0.00,
    views INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    INDEX idx_category (category_id),
    INDEX idx_rating (rating),
    INDEX idx_title (title)
);

-- ============================================
-- Table: ingredients
-- Stores recipe ingredients
-- ============================================
CREATE TABLE IF NOT EXISTS ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id VARCHAR(10) NOT NULL,
    ingredient_text TEXT NOT NULL,
    sort_order INT DEFAULT 0,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    INDEX idx_recipe (recipe_id)
);

-- ============================================
-- Table: steps
-- Stores recipe preparation steps
-- ============================================
CREATE TABLE IF NOT EXISTS steps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id VARCHAR(10) NOT NULL,
    step_number INT NOT NULL,
    instruction TEXT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    INDEX idx_recipe (recipe_id),
    UNIQUE KEY unique_recipe_step (recipe_id, step_number)
);

-- ============================================
-- Table: users
-- Stores user information
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    profile_image VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username)
);

-- ============================================
-- Table: reviews
-- Stores user reviews for recipes
-- ============================================
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id VARCHAR(10) NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_recipe (user_id, recipe_id),
    INDEX idx_recipe (recipe_id),
    INDEX idx_user (user_id)
);

-- ============================================
-- Table: favorites
-- Stores user favorite recipes
-- ============================================
CREATE TABLE IF NOT EXISTS favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipe_id VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_favorite (user_id, recipe_id),
    INDEX idx_user (user_id),
    INDEX idx_recipe (recipe_id)
);

-- ============================================
-- Table: tags
-- Stores recipe tags for better categorization
-- ============================================
CREATE TABLE IF NOT EXISTS tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: recipe_tags
-- Junction table for recipes and tags (many-to-many)
-- ============================================
CREATE TABLE IF NOT EXISTS recipe_tags (
    recipe_id VARCHAR(10) NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (recipe_id, tag_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    INDEX idx_recipe (recipe_id),
    INDEX idx_tag (tag_id)
);

-- ============================================
-- Insert Categories
-- ============================================
INSERT INTO categories (name, description) VALUES
('Breakfast', 'Traditional Andhra breakfast dishes'),
('Lunch', 'Main course dishes for lunch'),
('Snacks', 'Quick bites and snacks'),
('Desserts', 'Sweet dishes and desserts'),
('Dinner', 'Evening meal dishes');

-- ============================================
-- Insert Sample Recipes
-- ============================================
INSERT INTO recipes (id, title, category_id, description, image, prep_time, cook_time, servings, difficulty) VALUES
('3f19', 'Pesarattu with Ginger Chutney', 1, 'A protein-rich pancake made with green gram, served with a tangy ginger chutney.', '/img/gallery/pessarattu.jpg', 15, 20, 4, 'Easy'),
('c5f5', 'Upma Pesarattu', 1, 'A delightful combination of upma served with protein-rich pesarattu.', '/img/gallery/upmap.jpg', 20, 25, 4, 'Medium'),
('ea62', 'Idli with Karivepaku Chutney', 1, 'Steamed rice cakes paired with flavorful curry leaf chutney.', '/img/gallery/idly.jpg', 10, 15, 4, 'Easy'),
('db85', 'Andhra-style Dosa with Peanut Chutney', 1, 'Crispy dosa served with creamy peanut chutney.', '/img/gallery/dosa.jpg', 10, 15, 4, 'Easy'),
('5be8', 'Uggani with Mirchi Bajji', 1, 'Soft rice puff paired with spicy chili fritters.', '/img/gallery/bajji.jpg', 15, 20, 4, 'Medium'),
('18b6', 'Pappu Charu (Dal Rasam) with Steamed Rice', 2, 'A tangy dal rasam made with tamarind and spices, served with steamed rice.', '/img/gallery/pappucharu.jpg', 15, 30, 4, 'Easy'),
('dd89', 'Gongura Pachadi with Hot Rice', 2, 'Tangy and spicy gongura chutney served with hot rice.', '/img/gallery/gpick.jpg', 10, 20, 4, 'Easy'),
('10e2', 'Pulasa Pulusu', 2, 'A seasonal delicacy, Andhra-style fish curry made with tamarind and spices.', '/img/gallery/fish2.jpg', 20, 40, 4, 'Hard'),
('8fbd', 'Mirchi Bajji (Stuffed Chili Fritters)', 3, 'Spicy and tangy green chilies stuffed with tangy filling, dipped in batter, and deep-fried.', '/img/gallery/sbajji.jpg', 15, 20, 6, 'Medium'),
('9af0', 'Bandar Laddu (Sweet Made of Besan)', 4, 'A traditional sweet made with roasted besan (gram flour) and sugar.', '/img/gallery/laddu.jpg', 10, 30, 8, 'Medium');

-- ============================================
-- Insert Ingredients for Sample Recipes
-- ============================================
INSERT INTO ingredients (recipe_id, ingredient_text, sort_order) VALUES
('3f19', '1 cup green gram (moong dal)', 1),
('3f19', '1/4 cup rice (optional)', 2),
('3f19', '1 green chili', 3),
('3f19', '1/2 inch ginger (grated)', 4),
('3f19', 'Salt to taste', 5),
('3f19', '1 tbsp oil (for frying)', 6),
('ea62', '2 cups idli batter', 1),
('ea62', '1/2 cup curry leaves', 2),
('ea62', '2 green chilies', 3),
('ea62', '1/4 cup grated coconut', 4),
('ea62', '1 tbsp tamarind paste', 5),
('ea62', 'Salt to taste', 6);

-- ============================================
-- Insert Steps for Sample Recipes
-- ============================================
INSERT INTO steps (recipe_id, step_number, instruction) VALUES
('3f19', 1, 'Soak green gram and rice (optional) for 4-6 hours.'),
('3f19', 2, 'Grind soaked ingredients with green chili, ginger, and salt into a smooth batter.'),
('3f19', 3, 'Heat a skillet, pour batter, and spread thinly.'),
('3f19', 4, 'Drizzle oil and cook until golden on both sides.'),
('3f19', 5, 'Serve hot with ginger chutney.'),
('ea62', 1, 'Steam the idlis using the batter.'),
('ea62', 2, 'For chutney, blend curry leaves, chilies, coconut, tamarind, and salt into a smooth paste.'),
('ea62', 3, 'Serve the idlis with karivepaku chutney.');

-- ============================================
-- Insert Sample Tags
-- ============================================
INSERT INTO tags (name) VALUES
('Vegetarian'),
('Vegan'),
('Gluten-Free'),
('Spicy'),
('Traditional'),
('Quick'),
('Healthy'),
('Protein-Rich'),
('Low-Calorie'),
('Andhra-Style');

-- ============================================
-- Insert Sample Recipe Tags
-- ============================================
INSERT INTO recipe_tags (recipe_id, tag_id) VALUES
('3f19', 1), ('3f19', 5), ('3f19', 8),
('ea62', 1), ('ea62', 5), ('ea62', 7),
('db85', 1), ('db85', 5), ('db85', 6),
('8fbd', 1), ('8fbd', 4), ('8fbd', 5);

-- ============================================
-- Create Views for Common Queries
-- ============================================

-- View: Recipe Details with Category
CREATE OR REPLACE VIEW vw_recipe_details AS
SELECT 
    r.id,
    r.title,
    c.name AS category,
    r.description,
    r.image,
    r.prep_time,
    r.cook_time,
    r.servings,
    r.difficulty,
    r.rating,
    r.views,
    r.created_at
FROM recipes r
JOIN categories c ON r.category_id = c.id;

-- View: Recipe with Ingredients Count
CREATE OR REPLACE VIEW vw_recipe_summary AS
SELECT 
    r.id,
    r.title,
    c.name AS category,
    COUNT(DISTINCT i.id) AS ingredient_count,
    COUNT(DISTINCT s.id) AS step_count,
    r.rating,
    r.views
FROM recipes r
JOIN categories c ON r.category_id = c.id
LEFT JOIN ingredients i ON r.id = i.recipe_id
LEFT JOIN steps s ON r.id = s.recipe_id
GROUP BY r.id, r.title, c.name, r.rating, r.views;

-- View: Popular Recipes
CREATE OR REPLACE VIEW vw_popular_recipes AS
SELECT 
    r.id,
    r.title,
    c.name AS category,
    r.rating,
    r.views,
    COUNT(DISTINCT f.id) AS favorite_count
FROM recipes r
JOIN categories c ON r.category_id = c.id
LEFT JOIN favorites f ON r.id = f.recipe_id
GROUP BY r.id, r.title, c.name, r.rating, r.views
ORDER BY r.views DESC, r.rating DESC
LIMIT 10;

-- ============================================
-- Stored Procedures
-- ============================================

-- Procedure: Get Recipe Full Details
DELIMITER //
CREATE PROCEDURE sp_get_recipe_details(IN recipe_id_param VARCHAR(10))
BEGIN
    -- Get recipe basic info
    SELECT * FROM vw_recipe_details WHERE id = recipe_id_param;
    
    -- Get ingredients
    SELECT ingredient_text FROM ingredients 
    WHERE recipe_id = recipe_id_param 
    ORDER BY sort_order;
    
    -- Get steps
    SELECT step_number, instruction FROM steps 
    WHERE recipe_id = recipe_id_param 
    ORDER BY step_number;
    
    -- Get tags
    SELECT t.name FROM tags t
    JOIN recipe_tags rt ON t.id = rt.tag_id
    WHERE rt.recipe_id = recipe_id_param;
    
    -- Update view count
    UPDATE recipes SET views = views + 1 WHERE id = recipe_id_param;
END //
DELIMITER ;

-- Procedure: Add Recipe Review
DELIMITER //
CREATE PROCEDURE sp_add_review(
    IN recipe_id_param VARCHAR(10),
    IN user_id_param INT,
    IN rating_param INT,
    IN comment_param TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error adding review';
    END;
    
    START TRANSACTION;
    
    -- Insert or update review
    INSERT INTO reviews (recipe_id, user_id, rating, comment)
    VALUES (recipe_id_param, user_id_param, rating_param, comment_param)
    ON DUPLICATE KEY UPDATE 
        rating = rating_param,
        comment = comment_param,
        updated_at = CURRENT_TIMESTAMP;
    
    -- Update recipe average rating
    UPDATE recipes 
    SET rating = (
        SELECT AVG(rating) 
        FROM reviews 
        WHERE recipe_id = recipe_id_param
    )
    WHERE id = recipe_id_param;
    
    COMMIT;
END //
DELIMITER ;

-- Procedure: Search Recipes
DELIMITER //
CREATE PROCEDURE sp_search_recipes(IN search_term VARCHAR(255))
BEGIN
    SELECT DISTINCT
        r.id,
        r.title,
        c.name AS category,
        r.description,
        r.image,
        r.rating,
        r.views
    FROM recipes r
    JOIN categories c ON r.category_id = c.id
    LEFT JOIN ingredients i ON r.id = i.recipe_id
    LEFT JOIN tags t ON r.id IN (SELECT recipe_id FROM recipe_tags WHERE tag_id = t.id)
    WHERE 
        r.title LIKE CONCAT('%', search_term, '%')
        OR r.description LIKE CONCAT('%', search_term, '%')
        OR i.ingredient_text LIKE CONCAT('%', search_term, '%')
        OR t.name LIKE CONCAT('%', search_term, '%')
    ORDER BY r.rating DESC, r.views DESC;
END //
DELIMITER ;

-- ============================================
-- Triggers
-- ============================================

-- Trigger: Validate Rating Before Insert
DELIMITER //
CREATE TRIGGER trg_validate_rating_insert
BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END //
DELIMITER ;

-- Trigger: Validate Rating Before Update
DELIMITER //
CREATE TRIGGER trg_validate_rating_update
BEFORE UPDATE ON reviews
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END //
DELIMITER ;

-- ============================================
-- Indexes for Performance Optimization
-- ============================================
CREATE INDEX idx_recipes_category_rating ON recipes(category_id, rating DESC);
CREATE INDEX idx_recipes_views ON recipes(views DESC);
CREATE INDEX idx_reviews_recipe_rating ON reviews(recipe_id, rating);
CREATE FULLTEXT INDEX idx_recipe_search ON recipes(title, description);

-- ============================================
-- Sample User Data (for testing)
-- ============================================
INSERT INTO users (username, email, password_hash, full_name) VALUES
('admin', 'admin@flavourvault.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User'),
('john_doe', 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Doe'),
('jane_smith', 'jane@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane Smith');

-- ============================================
-- Sample Reviews
-- ============================================
INSERT INTO reviews (recipe_id, user_id, rating, comment) VALUES
('3f19', 2, 5, 'Absolutely delicious! The ginger chutney was perfect.'),
('ea62', 3, 4, 'Great recipe, but I added more curry leaves for extra flavor.'),
('db85', 2, 5, 'Best dosa recipe I have tried!');

-- ============================================
-- Sample Favorites
-- ============================================
INSERT INTO favorites (user_id, recipe_id) VALUES
(2, '3f19'),
(2, 'ea62'),
(3, 'db85'),
(3, '8fbd');

-- ============================================
-- Useful Queries (Comments for reference)
-- ============================================

-- Get all recipes by category:
-- SELECT * FROM vw_recipe_details WHERE category = 'Breakfast';

-- Get top rated recipes:
-- SELECT * FROM recipes ORDER BY rating DESC LIMIT 10;

-- Get most viewed recipes:
-- SELECT * FROM recipes ORDER BY views DESC LIMIT 10;

-- Get user's favorite recipes:
-- SELECT r.* FROM recipes r
-- JOIN favorites f ON r.id = f.recipe_id
-- WHERE f.user_id = 1;

-- Search recipes by ingredient:
-- SELECT DISTINCT r.* FROM recipes r
-- JOIN ingredients i ON r.id = i.recipe_id
-- WHERE i.ingredient_text LIKE '%coconut%';

-- Get recipes by tag:
-- SELECT r.* FROM recipes r
-- JOIN recipe_tags rt ON r.id = rt.recipe_id
-- JOIN tags t ON rt.tag_id = t.id
-- WHERE t.name = 'Vegetarian';

-- ============================================
-- End of Database Schema
-- ============================================

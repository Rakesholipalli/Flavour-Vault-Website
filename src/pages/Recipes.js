import { useState, useEffect } from "react";
import { FaSearch } from "react-icons/fa";
import RecipeCard from "../components/RecipeCard";
import "../styles/Recipes.css";
import recipeData from "../data/details.json";

export default function Recipes() {
    const [recipes, setRecipes] = useState([]);
    const [searchTerm, setSearchTerm] = useState("");
    const [selectedCategory, setSelectedCategory] = useState("All");
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    const categories = ["All", "Breakfast", "Lunch", "Dinner", "snacks", "Desserts"];

    // Load recipes from static JSON file
    useEffect(() => {
        try {
            setLoading(true);
            setRecipes(recipeData.recipes);
        } catch (err) {
            setError("Failed to load recipes");
        } finally {
            setLoading(false);
        }
    }, []);

    // Filter recipes based on search term and selected category
    const filteredRecipes = recipes.filter((recipe) => {
        const matchesSearch = recipe.title.toLowerCase().includes(searchTerm.toLowerCase());
        const matchesCategory = selectedCategory === "All" || recipe.category === selectedCategory;
        return matchesSearch && matchesCategory;
    });

    if (loading) return <p>Loading recipes...</p>;
    if (error) return <p>Error: {error}</p>;

    return (
        <div className="recipes-page">
            {/* Category Filter Buttons */}
            <div className="category-filter">
                {categories.map((category) => (
                    <button
                        key={category}
                        className={category === selectedCategory ? "active" : ""}
                        onClick={() => setSelectedCategory(category)}
                    >
                        {category}
                    </button>
                ))}
            </div>

            {/* Search Bar */}
            <div className="search-bar">
                <div className="search-container">
                    <input
                        type="text"
                        placeholder="Search recipes..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                    <FaSearch className="search-icon" />
                </div>
            </div>

            {/* Recipe Cards Display */}
            <div className="recipes-container">
                {filteredRecipes.length > 0 ? (
                    filteredRecipes.map((recipe, index) => (
                        <RecipeCard key={index} recipe={recipe} />
                    ))
                ) : (
                    <p>No recipes found!</p>
                )}
            </div>
        </div>
    );
}

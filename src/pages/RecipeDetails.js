import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { FaArrowLeft, FaPrint } from "react-icons/fa";
import "../styles/Recipes.css";
import recipeData from "../data/details.json";

export default function RecipeDetails() {
    const { title } = useParams(); // Get recipe title from the URL
    const navigate = useNavigate();

    const [recipe, setRecipe] = useState(null); // State for the specific recipe
    const [loading, setLoading] = useState(true); // Loading state
    const [error, setError] = useState(null); // Error state

    useEffect(() => {
        try {
            console.log("Loading recipe from static data...");
            
            // Get base recipes from JSON
            const baseRecipes = recipeData.recipes;
            
            // Get user-added recipes from localStorage
            const userRecipes = JSON.parse(localStorage.getItem("userRecipes") || "[]");
            
            // Combine both
            const allRecipes = [...userRecipes, ...baseRecipes];
            
            const foundRecipe = allRecipes.find(
                (r) => r.title.toLowerCase() === decodeURIComponent(title).toLowerCase()
            );

            if (!foundRecipe) throw new Error("Recipe not found");
            setRecipe(foundRecipe);
        } catch (err) {
            console.error("Error loading recipe:", err);
            setError(err.message);
        } finally {
            setLoading(false);
        }
    }, [title]);

    if (loading) return <p>Loading recipe...</p>;

    if (error) {
        return (
            <div className="recipe-not-found">
                <h2>{error}</h2>
                <button onClick={() => navigate(-1)} className="back-btn">
                    Go Back
                </button>
            </div>
        );
    }

    return (
        <div className="recipe-details">
            <button onClick={() => navigate(-1)} className="back-btn">
                <FaArrowLeft /> Back
            </button>

            <div className="recipe-content">
                <div className="recipe-image">
                    <img src={recipe.image} alt={recipe.title} className="recipe-image-style" />
                </div>
                <div className="recipe-info">
                    <h1 className="recipe-title">{recipe.title}</h1>
                    <p className="recipe-description">{recipe.description}</p>

                    <h2>Ingredients</h2>
                    <ul className="ingredients-list">
                        {recipe.ingredients.map((ingredient, index) => (
                            <li key={index}>{ingredient}</li>
                        ))}
                    </ul>

                    <h2>Steps</h2>
                    <ol className="steps-list">
                        {recipe.steps.map((step, index) => (
                            <li key={index}>{step}</li>
                        ))}
                    </ol>

                    <div className="actions">
                        <button className="print-btn" onClick={() => window.print()}>
                            <FaPrint /> Print Recipe
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}

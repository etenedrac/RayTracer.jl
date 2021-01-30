function translation(x::T,y::T,z::T)::Array{T,2} where {T<:Real}
    return [1 0 0 x; 0 1 0 y; 0 0 1 z; 0 0 0 1]
end

function translation(x::Real,y::Real,z::Real)
    return translation(promote(x,y,z)...)
end

function scaling(x::T,y::T,z::T)::Array{T,2} where {T<:Real}
    return [x 0 0 0; 0 y 0 0; 0 0 z 0; 0 0 0 1]
end

function scaling(x::Real,y::Real,z::Real)
    return scaling(promote(x,y,z)...)
end

function rotation_x(angle::T)::Array{T,2} where {T<:Real}
    return [1 0 0 0; 0 cos(angle) -sin(angle) 0; 0 sin(angle) cos(angle) 0; 0 0 0 1]
end

function rotation_y(angle::T)::Array{T,2} where {T<:Real}
    return [cos(angle) 0 sin(angle) 0; 0 1 0 0; -sin(angle) 0 cos(angle) 0; 0 0 0 1]
end

function rotation_z(angle::T)::Array{T,2} where {T<:Real}
    return [cos(angle) -sin(angle) 0 0; sin(angle) cos(angle) 0 0; 0 0 1 0; 0 0 0 1]
end

function shearing(x_y::T,x_z::T,y_x::T,y_z::T,z_x::T,z_y::T)::Array{T,2} where {T<:Real}
    return [1 x_y x_z 0; y_x 1 y_z 0; z_x z_y 1 0; 0 0 0 1]
end
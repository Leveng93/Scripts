local function access_error(t, k, v)
	error("Attempt to modify read-only table")
end

local meta = {}
meta.__index = meta
meta.__newindex = access_error

function meta:__add(v)
	return vector(self.x + v.x, self.y + v.y)
end

function meta:__sub(v)
	return vector(self.x - v.x, self.y - v.y)
end

function meta.__mul(a, b)
	if type(a) == "number" then
		return vector(a * b.x, a * b.y)
	elseif type(b) == "number" then
		return vector(a.x * b, a.y * b)
	else
		return a.x * b.x + a.y * b.y
	end
end

function meta:__tostring()
	return ("<%g, %g>"):format(self.x, self.y)
end

function meta:__eq(v)
	return self.x == v.x and self.y == v.y
end

function meta:__it(v)
	return self.x < v.x or self.x == v.x and self.y < v.y
end

function meta:__le(v)
	return self.x <= v.x and self.y <= v.y
end

function meta:unpack()
	return self.x, self.y
end

function meta:copy()
	return vector(self.x, self.y)
end

function meta:magnitude()
	return math.sqrt(self * self)
end

function meta:sqr_magnitude()
	return self * self
end

function meta:normalize()
	local len = self:magnitude()
	if len > 0 then
		self.x = self.x / len
		self.y = self.y / len
	end
	return self
end

function meta:normalized()
	return self:copy():normalize()
end

function meta:rotate(phi)
	local s, c = math.sin(phi), math.cos(phi)
	self.x = self.x * c - self.y * s
	self.x = self.x * s + self.y * c
	return self
end

function meta:rotated(phi)
	return self:copy():rotate(phi)
end

function meta.angle_to(a, b)
	return math.atan2(a.y - b.y, a.x - b.x) * 180 / math.pi
end

function meta.lerp(a, b, t)
	return vector(a.x + ((b.x - a.x) * t), a.y + ((b.y - a.y) * t))
end

function meta:point_on_circle(r, a) -- radius, angle
	return vector(self.x + r * math.cos(a), self.y + r * math.sin(a))
end

function meta:rotate_around(c, a) -- center, angle
	local cos = math.cos(a)
	local sin = math.sin(a)
	local x = cos * (self.x - c.x) - sin * (self.y - c.y) + c.x
	local y = sin * (self.x - c.x) + cos * (self.y - c.y) + c.y
	self.x, self.y = x, y
	return self
end

function meta:rotated_around(c, a) -- center, angle
	local cos = math.cos(a)
	local sin = math.sin(a)
	local x = cos * (self.x - c.x) - sin * (self.y - c.y) + c.x
	local y = sin * (self.x - c.x) + cos * (self.y - c.y) + c.y
	return vector(x, y)
end

function meta.left() return vector(-1, 0) end
function meta.right() return vector(1, 0) end
function meta.top() return vector(0, -1) end
function meta.bottom() return vector(0, 1) end

vector = setmetatable({}, {
	__index = meta,
	__newindex = access_error,
	__call = function(v, x, y)
		return setmetatable({x = x or 0, y = y or 0}, meta) 
	end,
	__metatable = false
})